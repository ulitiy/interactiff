class Relation
  include Mongoid::Document

  belongs_to :from, class_name: "Block", inverse_of: :out_relations
  belongs_to :to, class_name: "Block", inverse_of: :to_relations
  belongs_to :game
  validates_presence_of :from, :to
  validates_uniqueness_of :to_id, scope: :from_id
  attr_accessible :from_id, :to_id, :game_id

  before_create :set_ids

  # Overrides as_json adding id field
  def as_json options={}#t
    super options.merge(:methods=>[:id])
  end

  # Sets game property if source and target belongs to one
  def set_ids
    self.game_id=from.game_id if from.game_id==to.game_id
  end

  # @return [Array] relations, that can be shown in current context (game or outside)
  def self.relations_collection blocks,id
    return [] if id=="0"# || !b.parent_game
    b=Block.find id
    unless b.parent_game #если снаружи игры
      return blocks.reduce [] { |arr,b| arr+=b.out_relations }
    end
    b.parent_game.game_relations
  end

end
