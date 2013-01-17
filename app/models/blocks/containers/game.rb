# encoding: UTF-8
class Game < Block
  field :name, type: String, default: ""
  field :description, type: String, default: ""
  field :guest_access, type: Boolean, default: true

  has_many :descendants, class_name: 'Block', inverse_of: :game
  has_many :game_relations, class_name: 'Relation', inverse_of: :game
  has_many :descendant_events, class_name: 'Event', inverse_of: :game
  has_many :variables, dependent: :destroy

  has_and_belongs_to_many :members, class_name: "User", inverse_of: "member_of_games", index: true

  attr_accessible :name, :description, :guest_access

  alias domain parent

  before_validation :new_game, on: :create

  def new_game
    self.name=I18n.t("admin.games.new")
    c=Clock.create! parent: self, x: 30, y: 30, title: "Игра начнется по часам"
    gs=GameStarted.create! parent: self, x: 280, y: 100, title: "Начало игры"
    Relation.create from: c, to: gs
    t1=Task.create! parent: self, x: 530, y: 170, name: "Задание 1", title: "с выбором ответа", input_type: "link"
    tg1=TaskGiven.create! parent: t1, x: 100, y: 100
    Relation.create! from: gs, to: tg1
    h=Hint.create! parent: t1, x: 270, y: 100, body: "Это текст первого задания. Вы можете его редактировать в панели свойств справа, а также использовать html редактор."
    Relation.create! from: tg1, to: h
    a1=Answer.create! parent: t1, x: 550, y: 100, body: "Верный ответ"
    tp1=TaskPassed.create! parent: t1, x: 800, y: 100
    Relation.create! from: a1, to: tp1
    Answer.create! parent: t1, x: 550, y: 180, body: "Неверный ответ"
    gp=GamePassed.create! parent: self, x: 800, y: 310, title: "Игра пройдена, Ура!"
    Relation.create from: tp1, to: gp
  end

  def path
    [self]
  end

  # @return [Array] users, that have manage access to the game
  def authors
    roles.map { |role| role.user if role.access.in? [:manage,:manage_roles] }
  end
end
