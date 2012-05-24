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

  # Sets game and task properties using parent
  def set_ids
    self.game=self.parent.parent_game if self.parent
    self.task=self.parent.parent_task if self.parent
  end

  # Overriden as_json adding type and id fields
  def as_json options={}#t
    super options.merge(:methods=>[:type,:id])
  end

  # @return [String] block class name
  def type
    self.class.name
  end

  # @return [Array] all ancestors + self
  def path #t
    return [self] unless self.parent
    self.parent.path+[self]
  end

  # @return [Game] first Game in path (self or ancestor)
  def parent_game #t
   return self if self.class==Game
   self.game
  end

  # @return [Game] first Task in path (self or ancestor)
  def parent_task #t
   return self if self.class==Task
   self.task
  end

  # @return [Array] all descendants (children + their descentants)
  def descendants #t
    children.reduce(children) do |arr,c|
      arr+c.descendants
    end
  end

  alias direct_descendants descendants #т.к. для экономии времени сделаем прямую ссылку на некоторые типы контейнеров

  # @param [Integer] id id of current page (parent)
  # @return [Array] all blocks necessary for requested page: in game – game path+descendants, all domains or domain children otherwise+I/O
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
