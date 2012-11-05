class Game < Block
  field :name, type: String, default: ""
  field :description, type: String, default: ""

  has_many :descendants, class_name: 'Block', inverse_of: :game
  has_many :game_relations, class_name: 'Relation', inverse_of: :game
  has_many :descendant_events, class_name: 'Event', inverse_of: :game

  has_and_belongs_to_many :members, class_name: "User", inverse_of: "member_of_games", index: true

  attr_accessible :name, :description

  alias domain parent

  # @return [Array] users, that have manage access to the game
  def authors
  	roles.map { |role| role.user if role.access.in? [:manage,:manage_roles] }
  end
end
