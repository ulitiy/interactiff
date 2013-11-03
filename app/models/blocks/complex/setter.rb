class Setter < EvalBlock

  belongs_to :variable, class_name: "Variable", inverse_of: nil, index: true
  field :expression, type: String, default: ""

  before_save :set_variable
  attr_accessible :expression, :variable

  # sets variable from the expression
  def set_variable
    var_name=EvalBlock.lasgn(expression)
    self.variable=var_name.present? ? Variable.find_or_create_by(game: game, name: var_name) : nil
  end

  # creates an event with variable value
  def create_event options
    super options.merge variable: variable, var_value: calculate_value(right_part,options)
  end

  def right_part
    expression.scan(/\A#{variable.name}=(.+)\Z/)[0][0]
  end

  # setter should hit all checkers of the variable
  def blocks_to_hit
    variable.checkers if variable
  end

end
