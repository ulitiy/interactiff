class Answer < Block
  field :body, type: String, :null => false, :default => ""
  attr_accessible :body
end
