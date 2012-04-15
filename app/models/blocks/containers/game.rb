class Game < Block
  acts_as_citier
  has_many :descendants, class_name: 'Block', foreign_key: 'game_id'#, dependent: :destroy #override
  has_many :relations#, dependent: :destroy
  attr_accessible :name, :description
  validates_presence_of :name
end
