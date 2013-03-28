class Message < Block
  field :message, type: String, :default => ""
  field :message_type, type: String, :default => "success"
  attr_accessible :message, :message_type
end
