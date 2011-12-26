class Answer < Block
  acts_as_citier

  belongs_to :task

  attr_accessible :body

  validates_presence_of :body,:task

end
