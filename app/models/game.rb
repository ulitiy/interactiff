class Game < Block
  acts_as_citier

  belongs_to :domain
  has_many :tasks, :dependent=>:destroy

  attr_accessible :name, :description, :tasks_attributes
  accepts_nested_attributes_for :tasks, :allow_destroy=>true

  validates_presence_of :domain
  validates_presence_of :name
end
