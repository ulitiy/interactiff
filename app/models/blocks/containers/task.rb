class Task < Block
  acts_as_citier

  attr_accessible :name, :comment

  validates_presence_of :name
end
