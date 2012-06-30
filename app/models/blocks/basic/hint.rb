class Hint < Block
  field :body, type: String, :default => ""

  attr_accessible :body
end
