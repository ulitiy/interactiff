# encoding: UTF-8
class EvalBlock < Block

  ALLOWED_METHODS=[:[],:+,:-,:*,:/,:%,:==,:>=,:>,:<,:<=,:===,:!=,:to_a,:to_s,:to_i,:to_f,:sqrt]
  EVAL_TIMEOUT=0.5

  attr_accessor :vars

  # calculates value from the expression
  # game, user, handler (for last input)
  def calculate_value expr,options
    get_vars expr, options
    execute expr
  end

  # gets var values from the DB
  def get_vars expr, options
    @vars={}
    for var_name in var_list(expr) do
      if var_name=="last_answer"
        @vars[var_name]=options[:handler].last_answer; #TODO: плохо -> handler.options[:handler] тоже. М.б. синглтон?
      else
        @vars[var_name]=Variable.where(game: options[:game], name: var_name).first.value(options)
      end
    end
  end

  # 9**999999, @t=''
  # Executes unsafe ruby code in safe env
  def execute str
    begin
      @t=Thread.start do
        sandbox str
      end
      @t.kill unless @t.join(EVAL_TIMEOUT)
      @t.value
    rescue Exception => e
      raise e
      #TODO: log exception here
    end
  end

  def sandbox str
    s=Shikashi::Sandbox.new
    p=Shikashi::Privileges.new
    p.allow_methods *ALLOWED_METHODS
    p.allow_const_read :Math
    p.allow_global_write :$SAFE
    p.allow_global_read :$SANDBOX_VARS
    $SANDBOX_VARS=@vars
    s.run p, sandbox_string(str)
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
    RubyParser.new.parse(str).var_search
  end

  def var_list str
    self.class.var_list str
  end

  def self.lasgn str
    p=RubyParser.new.parse(str)
    p[1].to_s if p && p[0]==:lasgn
  end

end
