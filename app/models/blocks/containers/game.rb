class Game < Block
  field :name, type: String
  field :description, type: String

  has_many :descendants, class_name: 'Block', inverse_of: :game
  has_many :game_relations, class_name: 'Relation', inverse_of: :game

  attr_accessible :name, :description
end
