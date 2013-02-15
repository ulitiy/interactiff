class Setter < EvalBlock

  belongs_to :variable, class_name: "Variable", inverse_of: nil, index: true
  field :expression, type: String, default: ""

  before_save :set_variable
  attr_accessible :expression, :variable

  # sets variable from the expression
  def set_variable
    arr=expression.scan(/\A(#{EvalBlock.var_reg})=.+/)[0]
    return unless arr
    var_name=arr[0]
    self.variable=Variable.find_or_create_by game: game, name: var_name #Variable.where(game: game, name: var_name).first
  end

  # creates an event with variable value
  def create_event options
    Event.create options.merge block: self, variable: variable, var_value: calculate_value(right_part,options)
  end

  def right_part
    expression.scan(/\A#{EvalBlock.var_reg}=(.+)/)[0][0]
  end

  # setter should hit all checkers of the variable
  def blocks_to_hit
    variable.checkers
  end

end
