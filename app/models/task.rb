class Task < Block
  acts_as_citier

  belongs_to :game
  has_many :hints, :dependent=>:destroy
  has_many :answers, :dependent=>:destroy

  attr_accessible :name, :comment

  validates_presence_of :name, :game

end
