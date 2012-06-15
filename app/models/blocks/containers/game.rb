class Game < Block
  field :name, type: String, :null => false, :default => ""
  field :description, type: String, :null => false, :default => ""

  has_many :descendants, class_name: 'Block', inverse_of: :game
  has_many :game_relations, class_name: 'Relation', inverse_of: :game

  attr_accessible :name, :description

  alias domain parent
end
