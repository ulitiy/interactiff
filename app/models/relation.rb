class Relation
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :from, class_name: "Block", inverse_of: :out_relations, index: true
  belongs_to :to, class_name: "Block", inverse_of: :to_relations, index: true
  belongs_to :game, inverse_of: :game_relations, index: true

  validates_presence_of :from, :to
  validates_uniqueness_of :to_id, scope: :from_id
  attr_accessible :from_id, :to_id, :game_id, :from, :to

  before_create :set_ids
  after_create :backtrack

  # Overrides as_json adding id field
  def as_json options={}#t
    super options.merge(:methods=>[:id])
  end

  # Sets game property if source and target belongs to one
  def set_ids
    self.game_id=from.game_id if from.game_id==to.game_id
  end

  # @return [Array] relations, that can be shown in current context (game or outside)
  def self.relations_collection id, blocks=[]
    return [] if id=="0"
    b=Block.find id
    unless b.parent_game #если снаружи игры
      return blocks.reduce [] { |arr,b1| arr+=b1.out_relations }
    end
    b.parent_game.game_relations
  end



  def backtrack
    from.events.each do |event|
      attrs=event.attributes.symbolize_keys
      to.hit attrs.merge(user: User.where(id: attrs[:user_id]).first,parent: event,source_id: event.source_id||event.id, input: nil, reason: nil)
    end
  end

end
