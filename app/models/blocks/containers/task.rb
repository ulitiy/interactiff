class Task < Block
  field :name, type: String

  has_many :descendants, class_name: 'Block', inverse_of: :task
  attr_accessible :name
end
