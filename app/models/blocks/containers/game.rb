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

  def new_game
    self.name=I18n.t("admin.game.new") if name.blank?
    gs=GameStarted.create! parent: self, x: 50, y: 50#, title: "Начало игры"
    # t1=Task.create! parent: self, x: 530, y: 170, name: "Задание 1", title: "с выбором ответа", input_type: "link"
    # tg1=TaskGiven.create! parent: t1, x: 100, y: 100, container_target: true,
                          # body: "Это текст первого задания. Вы можете его редактировать в панели свойств справа, а также использовать html редактор.",
                          # title: "Дано"
    # Relation.create! from: gs, to: tg1
    # a1=Answer.create! parent: t1, x: 550, y: 100, body: "Верный ответ"
    # tp1=TaskPassed.create! parent: t1, x: 800, y: 100, container_source: true
    # Relation.create! from: a1, to: tp1
    # Answer.create! parent: t1, x: 550, y: 180, body: "Неверный ответ"
    gp=GamePassed.create! parent: self, x: 800, y: 500#, title: "Игра пройдена, Ура!"
    # Relation.create from: tp1, to: gp
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
    game_started_block.save
  end

  def game_started_block
    children.where(_type: "GameStarted").first
  end

  def timeline_events
    @te||=descendant_events.block_type("TaskPassed").order_by(time: -1)
  end

  def timeline_sorted
    timeline_events.to_a.group_by(&:user_id).map { |k,v| {user: User.find(k), events: v} }
  end
end
