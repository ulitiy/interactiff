class Checker < EvalBlock

  has_and_belongs_to_many :variables, class_name: "Variable", inverse_of: :checkers, index: true, dependent: :nullify #https://github.com/mongoid/mongoid/issues/2630
  field :expression, type: String, default: ""

  before_save :set_variables
  attr_accessible :expression, :variables

  # sets the variables from the expression
  def set_variables
    self.variables=Variable.where(game: game).in(name: var_list(expression)).to_a
  end

  def hot? options
    calculate_value expression, options
  end

end
