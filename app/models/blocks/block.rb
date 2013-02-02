# Abstract potential action/event
class Block
  include Mongoid::Document
  include Mongoid::Timestamps
  include BlockBehavior
  include BlockAdmin

  field :x, type: Integer, default: 0
  field :y, type: Integer, default: 0
  field :title, type: String, default: ""
  field :scope, type: Symbol, default: :for_one

  belongs_to :parent, class_name: "Block", inverse_of: :children, index: true #TODO validate
  belongs_to :game, class_name: "Game", inverse_of: :descendants, index: true
  belongs_to :task, class_name: "Task", inverse_of: :descendants, index: true
  has_many :children, class_name: "Block", inverse_of: :parent, dependent: :destroy
  has_many :in_relations, class_name: "Relation", inverse_of: :to, dependent: :destroy # НЕ ТРОГАЙ, висячая связь валит out_blocks при удалении
  has_many :out_relations, class_name: "Relation", inverse_of: :from, dependent: :destroy # разве что здесь... но и то мусорно

  # has_many :inputs, class_name: "Input", inverse_of: :parent
  # has_many :outputs, class_name: "Output", inverse_of: :parent
  has_many :events, class_name: 'Event', inverse_of: :block, dependent: :destroy
  has_many :roles, dependent: :destroy

  attr_accessible :x,:y,:title,:parent,:parent_id

  default_scope order_by(y:1,x:1)

  before_create :set_ids
  after_initialize :set_ids

  index y: 1, x: 1

  def personal
    false
  end

  # Sets game and task properties using parent
  def set_ids
    return if self.game_id #designer performance
    self.game||=self.parent.parent_game if self.parent
    self.task||=self.parent.parent_task if self.parent
  end

end
