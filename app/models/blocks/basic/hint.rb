class Hint < Block
  include WithVars
  with_vars :body
  field :body, type: String, :default => ""

  attr_accessible :body

end
