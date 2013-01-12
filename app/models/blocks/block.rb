class Block
  include Mongoid::Document
  include Mongoid::Timestamps
  include BlockBehavior

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

  has_many :inputs, class_name: "Input", inverse_of: :parent
  has_many :outputs, class_name: "Output", inverse_of: :parent
  has_many :events, class_name: 'Event', inverse_of: :block, dependent: :destroy
  has_many :roles, dependent: :destroy

  attr_accessible :x,:y,:title,:parent,:parent_id

  default_scope order_by(y:1,x:1)

  before_create :set_ids
  after_initialize :set_ids

  #TODO: _type
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

  # Overriden as_json adding type and id fields
  def as_json options={}
    super options.merge(:methods=>[:type,:id,:digest])
  end

  # @return [String] block class name
  def type
    self.class.name
  end

  # @return [Array] all ancestors + self
  def path
    return [self] unless self.parent
    self.parent.path+[self]
  end

  # @return [Game] first Game in path (self or ancestor)
  def parent_game
   return self if self.class==Game
   self.game
  end

  # @return [Game] first Task in path (self or ancestor)
  def parent_task
   return self if self.class==Task
   self.task
  end

  # @return [Array] all descendants (children + their descentants)
  def descendants
    children.reduce(children) do |arr,c|
      arr+c.descendants
    end
  end

  alias direct_descendants descendants #т.к. для экономии времени сделаем прямую ссылку на некоторые типы контейнеров

  # @param [Integer] id id of current page (parent)
  # @return [Array] all blocks necessary for requested page: in game – game path+descendants, all domains or domain children otherwise+I/O
  def self.master_collection id
    return Domain.all if id=="0"
    b=Block.find(id)
    if b.is_a? Domain
      c=b.children#.includes([:inputs, :outputs]) #все детишки (можно с ранней подгрузкой внуков)
      io=c.reduce([]) { |arr,child| arr+child.children.where(:_type=>{"$in"=>["Input","Output"]})} #все необходимые внуки
      return [b]+c+io #я, дети и внуки
    end
    b=b.parent_game
    b.path+b.descendants
  end


  # ПРОТЕСТИРОВАТЬ ПРИ ОТСУТСТВИИ КОМАНДЫ/ПОЛЬЗОВАТЕЛЯ для общих случаев, например общее присвоение переменной/проверка
  # @return Array descendant events of the game for user(his team and common), optionally by the var name
  def descendant_events_of options
    de=[]
    de+=descendant_events.block_type(options[:type]).for_one(options[:user]).var(options[:variable]) if options[:user]
    de+=descendant_events.block_type(options[:type]).for_team(options[:user].team).var(options[:variable]) if options[:user]&&options[:user].team_id
    de+=descendant_events.block_type(options[:type]).for_all.var(options[:variable])
  end

end
