class Message < Block
  field :body, type: String, :default => ""
  attr_accessible :body
end
