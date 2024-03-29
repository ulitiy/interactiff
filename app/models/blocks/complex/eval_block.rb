class EvalBlock < Block

  field :exception, type: String, default: nil

  ALLOWED_METHODS=[:[],:+,:-,:*,:/,:%,:==,:>=,:>,:<,:<=,:===,:!=,:to_a,:to_s,:to_i,:to_f,:sqrt,:rand,:now,:=~,:!~,
                    :each,:map,:reduce,:count,:find,:find_all,:sort,:sort_by,:min,:min_by,:max,:max_by,:select,:first,:last]
  EVAL_TIMEOUT=1

  attr_accessor :vars
  attr_accessible :exception

  # calculates value from the expression
  # game, user, handler (for last input)
  def calculate_value expr,options
    begin
      get_vars expr, options
      execute expr
    rescue Exception => e
      update_attribute :exception, e.message
      raise e
    end
  end

  # gets var values from the DB
  def get_vars expr, options
    @vars={}
    for var_name in var_list(expr) do
      if var_name=="last_answer"
        options[:handler]||=EventHandler.new user: options[:user], game: options[:game], task: options[:task] #TODO: test
        @vars[var_name]=options[:handler].last_answer; #TODO: плохо
      elsif var_name=~/^t_(.*)$/
        @vars[var_name]=options[:game].table($1).rows.order_by(_id:1).limit(100).to_a #TODO: find_or_create_by here((
      else
        @vars[var_name]=Variable.where(game: options[:game], name: var_name).first.value(options)
      end
    end
  end

  # 9**999999, @t=''
  # Executes unsafe ruby code in safe env
  def execute str
    @t=Thread.start do
      sandbox str
    end
    @t.kill unless @t.join(EVAL_TIMEOUT)
    @t.value
  end

  def sandbox str
    s=Shikashi::Sandbox.new
    p=Shikashi::Privileges.new
    p.allow_methods *ALLOWED_METHODS
    p.allow_const_read :Math
    p.allow_const_read :Time
    p.allow_global_write :$SAFE
    p.allow_global_read :$SANDBOX_VARS
    $SANDBOX_VARS=@vars
    s.run p, sandbox_string(str), :encoding => "utf-8"
  end

  def sandbox_string str
    <<-SANDBOX
      #{def_vars var_list(str)}
      $SAFE=4
      #{str}
    SANDBOX
  end

  def def_vars vl
    vl.map do |var|
      <<-VARS
        def self.#{var}
          $SANDBOX_VARS["#{var}"]
        end
      VARS
    end.join
  end

  # @return Array of variables used in the expression
  def self.var_list str
    arr=RubyParser.new.parse(str)
    arr.var_search if arr
  end

  def var_list str
    self.class.var_list str
  end

  def self.lasgn str
    p=RubyParser.new.parse(str)
    p[1].to_s if p && p[0]==:lasgn
  end

end
