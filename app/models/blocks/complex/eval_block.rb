# encoding: UTF-8
class EvalBlock < Block

  attr_accessor :vars

  # calculates value from the expression
  # game, user, handler (for last input)
  def calculate_value expr,options
    get_vars expr, options
    execute replace_vars expr
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

  # replaces engine vars in expression with local vars
  def replace_vars expr
    expr.gsub(self.class.var_reg) { |var| var=~self.class.const_reg ? var : "@vars['#{var}']" }
  end

  # 9**999999, @t=''
  # Executes unsafe ruby code in safe env
  def execute str
    begin
      @t=Thread.start do
        # yield
        $SAFE=4
        eval str
      end
      @t.kill unless @t.join(0.1)
      @t.value
    rescue Exception => e
      raise e
      #TODO: log exception here
    end
  end

  #TODO: convert methods to constants
  # @return RegExp for variable
  def self.var_reg
    /[а-яА-Яa-zA-Z0-9_\.][а-яА-Яa-zA-Z0-9_]*|[\'\"].*[\'\"]/
  end

  # @return RegExp for constants and methods
  def self.const_reg
    /\A[А-ЯA-Z0-9\.\"]/
  end

  # @return Array of variables used in the expression
  def var_list expr
    expr.scan(self.class.var_reg).uniq.reject { |var| var=~self.class.const_reg }
  end

end
