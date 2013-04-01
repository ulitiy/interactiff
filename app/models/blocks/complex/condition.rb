class Condition < EvalBlock

  field :expression, type: String, default: ""

  attr_accessible :expression

  def hot? options
    calculate_value expression, options
  end

end
