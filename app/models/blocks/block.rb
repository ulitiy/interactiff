class Block
  include Mongoid::Document
  include Mongoid::Timestamps

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












  # returns true, if the block should fire on hit. Is overriden by descendants
  def hot? options #срабатывать ли?!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    true
  end

  # method is called when the incoming relation is fired
  def hit options={}
    fire options if hot?(options)
  end

  # @return [Boolean] if there are any events, related to current user and this block
  def is_hit? options
    events.or({scope: :for_one, user_id: options[:user].id}, {scope: :for_team, team_id: options[:user].team_id}, {scope: :for_all}).any? #moped doesn't understand <model>
  end

  # @return [Boolean] if there are any events, related to this block
  def is_hit_by_any?
    events.any?
  end

  # method is called when hit and hot, or when forced
  # @return [Array] all events, arisen
  def fire options={}
    options.merge! scope: get_scope(options)
    mutex=options[:mutex]
    options.except! :force_scope, :game, :task, :mutex
    options.merge! team: options[:user].team if options[:scope]==:for_team
    options.reverse_merge! time: Time.now, game: game
    cs=CriticalSection.new(game_id).lock if mutex
      if personal && options[:scope]!=:for_one # мне это воспринять на свой счет? (вулкан задел жителя)
        events=for user in scope_users(options) do
          fire options.merge(scope: :for_one, user: user, force_scope: true) #проблема в том, что, если мы делаем P*, то у нас get_scope возвращается всегда for_all и fire уходит в бесконечную рекурсию
        end
        return events
      end
      event=create_event options
      block_actions options
      ret=[event]+hit_relations(options.merge(
        parent: event,
        source: options[:source]||event,
        responsible_user: nil,
        reason: nil,
        input: nil
      ))
    cs.unlock if mutex
    ret
  end

  # @returns event created
  def create_event options
    Event.create options.merge block: self
  end

  # @return [Symbol] scope to fire this and descendant blocks. It should be the max scope available.
  def get_scope options
    return options[:scope] if options[:force_scope]
    h={for_one:1, for_team:2, for_all:3}
    h.invert[ [h[options[:scope]] || 0, h[scope]].max ] #хитро
  end

  # method is called when block is fired (ex. send message)
  def block_actions options ; end

  # @return [Array] all blocks, from which relations go to this block (cause blocks)
  def in_blocks
    ids=in_relations.map &:from_id
    Block.find(*ids).to_a
  end

  # @return [Array] all blocks, to which relations go from this block (effect blocks)
  def out_blocks
    ids=out_relations.map &:to_id
    Block.find(*ids).to_a #to array if nil or one
  end

  alias blocks_to_hit out_blocks

  # @return [Array] all users, events should be created for
  def scope_users options
    case options[:scope]
      when :for_one then [options[:user]]
      when :for_team then options[:user].team.members
      when :for_all then game.members
    end
  end

  # hits all {#blocks_to_hit}.
  def hit_relations options
    blocks_to_hit.map { |block| block.hit(options) }.flatten
  end

  attr_accessor :t

end
