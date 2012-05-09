class Block < ActiveRecord::Base
  acts_as_citier

  belongs_to :parent, class_name: "Block" #TODO validate
  has_many :children, class_name: "Block", foreign_key: "parent_id", dependent: :destroy
  has_many :out_relations, class_name: "Relation", foreign_key: "from_id", dependent: :destroy
  has_many :in_relations, class_name: "Relation", foreign_key: "to_id"#, dependent: :destroy
  belongs_to :game
  belongs_to :task

  #functional
  has_many :game_starteds, foreign_key: "parent_id"
  has_many :game_passeds, foreign_key: "parent_id"
  has_many :inputs, foreign_key: "parent_id"
  has_many :outputs, foreign_key: "parent_id"
  has_many :task_givens, foreign_key: "parent_id"
  has_many :task_passeds, foreign_key: "parent_id"
  #containers
  has_many :games, foreign_key: "parent_id"
  has_many :tasks, foreign_key: "parent_id"
  #basic
  has_many :hints, foreign_key: "parent_id"
  has_many :answers, foreign_key: "parent_id"
  has_many :hosts, foreign_key: "parent_id"
  has_many :timers, foreign_key: "parent_id"

  attr_accessible :x,:y,:parent,:parent_id,:comment,:title

  before_create :set_ids

  def set_ids
    self.game=self.parent.parent_game if self.parent
    self.task=self.parent.parent_task if self.parent
  end

  def self.functional
    [:game_starteds,:game_passeds,:inputs,:outputs]
  end

  def as_json options={}
    {sid: id}.merge( super options.merge(:methods=>:type) )
  end

  def type
    self.class.name
  end

  def path #t
    return [self] unless self.parent
    self.parent.path+[self]
  end

  def parent_game #t
   return self if self.class==Game
   self.game
  end

  def parent_task #t
   return self if self.class==Task
   self.task
  end

  def descendants #t
    children.reduce(children) do |arr,c|
      arr+c.descendants
    end
  end

  alias direct_descendants descendants #т.к. для экономии времени сделаем прямую ссылку на некоторые типы контейнеров

  def self.master_collection id #t
    return Domain.all if id=="0"
    b=Block.find(id)
    if b.is_a? Domain
      c=b.children.includes(Block.functional)
      io=c.reduce([]) { |arr,child| arr+child.game_starteds+child.game_passeds+child.inputs+child.outputs}
      return [b]+c+io
    end
    b=b.parent_game
    arr=b.path+b.descendants
  end

end
