class Task < Block
  field :name, type: String, :default => ""
  field :input_type, type: String, :default => "textbox"

  has_many :descendants, class_name: 'Block', inverse_of: :task
  has_many :descendant_events, class_name: 'Event', inverse_of: :task
  attr_accessible :name, :input_type
  attr_accessor :passed
end
