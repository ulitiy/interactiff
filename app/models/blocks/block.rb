# Abstract potential action/event
class Block
  include Mongoid::Document
  include Mongoid::Timestamps
  include BlockBehavior
  include BlockAdmin
  extend Enumerize

  field :x, type: Integer, default: 0
  field :y, type: Integer, default: 0
  field :title, type: String, default: ""
  field :scope, type: String, default: "for_one"
  field :container_source, type: Boolean, default: false
  field :container_target, type: Boolean, default: false
  enumerize :scope, in: ["for_one","for_team","for_all"], default: "for_one"

  belongs_to :parent, class_name: "Block", inverse_of: :children, index: true #TODO validate
  belongs_to :game, class_name: "Game", inverse_of: :descendants, index: true, touch: true
  belongs_to :task, class_name: "Task", inverse_of: :descendants, index: true
  has_many :children, class_name: "Block", inverse_of: :parent, dependent: :destroy
  has_many :in_relations, class_name: "Relation", inverse_of: :to, dependent: :destroy # НЕ ТРОГАЙ, висячая связь валит out_blocks при удалении
  has_many :out_relations, class_name: "Relation", inverse_of: :from, dependent: :destroy # разве что здесь... но и то мусорно

  # has_many :inputs, class_name: "Input", inverse_of: :parent
  # has_many :outputs, class_name: "Output", inverse_of: :parent
  has_many :events, class_name: 'Event', inverse_of: :block, dependent: :destroy
  has_many :roles, dependent: :destroy

  attr_accessible :x,:y,:title,:parent,:parent_id,:container_source, :container_target, :scope

  before_create :set_ids
  after_initialize :set_ids
  # after_update :update_game

  index created_at: 1

  def personal
    false
  end

  # Sets game and task properties using parent
  def set_ids
    return if self.game_id #designer performance
    self.game||=self.parent.parent_game if self.parent
    self.task||=self.parent.parent_task if self.parent
  end

  def self.descendant_types
    [self.to_s]+self.descendants.map(&:to_s)
  end

  # def update_game
  #   if self.game_id
  #     self.game.touch
  #   end
  # end

end
