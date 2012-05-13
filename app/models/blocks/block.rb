class Block
  include Mongoid::Document

  field :x, type: Integer
  field :y, type: Integer
  field :title, type: String

  belongs_to :parent, class_name: "Block", index: true #TODO validate
  belongs_to :game, index: true
  belongs_to :task, index: true
  has_many :children, class_name: "Block", inverse_of: :parent, dependent: :destroy
  has_many :out_relations, class_name: "Relation", inverse_of: :from, dependent: :destroy
  has_many :in_relations, class_name: "Relation", inverse_of: :to#, dependent: :destroy

  has_many :inputs, class_name: "Input", inverse_of: :parent
  has_many :outputs, class_name: "Output", inverse_of: :parent

  attr_accessible :x,:y,:title,:parent,:parent_id

  before_create :set_ids #t

  def set_ids
    self.game=self.parent.parent_game if self.parent
    self.task=self.parent.parent_task if self.parent
  end

  def as_json options={}#t
    super options.merge(:methods=>[:type,:id])
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
      c=b.children#.includes([:inputs, :outputs]) #все детишки (можно с ранней подгрузкой внуков)
      io=c.reduce([]) { |arr,child| arr+child.children.where(:_type=>{"$in"=>["Input","Output"]})} #все необходимые внуки
      return [b]+c+io #я, дети и внуки
    end
    b=b.parent_game
    arr=b.path+b.descendants
  end

end
