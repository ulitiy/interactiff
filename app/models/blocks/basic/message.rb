class Message < Block
  extend Enumerize
  include AttrSanitizer
  include WithVars
  with_vars :message

  field :message, type: String, :default => ""
  field :message_type, type: String
  enumerize :message_type, in: [:success,:info,:alert], default: :success
  attr_accessible :message, :message_type
  sanitize :message
end
