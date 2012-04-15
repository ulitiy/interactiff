class Relation < ActiveRecord::Base
  belongs_to :from, class_name: "Block"
  belongs_to :to, class_name: "Block"
  belongs_to :game
  validates_presence_of :from, :to
  validates_uniqueness_of :to_id, scope: :from_id
  attr_accessible :from_id, :to_id, :game_id

  before_create :set_ids

  def set_ids
    self.game_id=from.game_id if from.game_id==to.game_id
  end
end
