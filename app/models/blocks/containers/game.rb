# encoding: UTF-8
class Game < Block
  extend Enumerize
  field :cover, type: String, default: ""
  field :name, type: String, default: ""
  field :description, type: String, default: ""
  field :category, type: String, default: "other"
  field :guest_access, type: Boolean, default: true
  field :example, type: Boolean, default: false
  # field :use_url_session, type: Boolean, default: true
  enumerize :category, in: ["widgets", "education", "games", "other" ], default: "other"
  mount_uploader :cover, QuestCoverUploader

  has_many :descendants, class_name: 'Block', inverse_of: :game
  has_many :game_relations, class_name: 'Relation', inverse_of: :game
  has_many :descendant_events, class_name: 'Event', inverse_of: :game
  has_many :variables, dependent: :destroy

  has_and_belongs_to_many :members, class_name: "User", inverse_of: "member_of_games", index: true

  attr_accessible :name, :description, :guest_access, :example, :category, :cover

  alias domain parent

  before_validation :new_game, on: :create
  after_create :start
  skip_callback :create, :after, :start, if: -> { @cloning }

  def deep_clone options={}
    @mapping=options[:mapping] || {}
    c=copy
    c.cloning=true
    c.updated_at=c.created_at=Time.now
    c.name+=I18n.t("games.copy")
    c.example=false
    c.save validate: false

    children.each do |child|
      child.deep_clone(parent_id: c.id, mapping: @mapping)
    end

    game_relations.each do |rel|
      Relation.create from: rel.from.copy, to: rel.to.copy
    end

    c.cloning=false
    c
  end

  def assign_to user
    user.engine_roles.create! access: :manage_roles, block: self
  end

  def new_game
    self.name=I18n.t("admin.game.new") if name.blank?
    ft=Task.create! parent: self, x:50, y: 50, name: I18n.t("admin.first_task.new"), order: 0
    gs=TaskGiven.create! parent: ft, x: 50, y: 50, container_target: true, body: I18n.t("admin.task_given.new"), title: I18n.t("admin.task_given.new")
    tp1=TaskPassed.create! parent: ft, x: 800, y: 600
  end

  def path
    [self]
  end

  # @return [Array] users, that have manage access to the game
  def authors
    roles.map { |role| role.user if role.access.in? [:manage,:manage_roles] }
  end

  def reset
    descendant_events.delete_all
    start()
  end

  def start
    first_task.given_block.fire(scope: "for_all",mutex: true)
  end

  # def game_started_block
  #   children.where(_type: "GameStarted").first
  # end

  def first_task
    children.where(_type: "Task").order_by(order: 1).first
  end

  def timeline_events
    @te||=descendant_events.block_type("TaskPassed").order_by(time: -1)
  end

  def timeline_sorted
    timeline_events.to_a.group_by(&:user_id).map { |k,v| {user: User.find(k), events: v} }
  end
end
