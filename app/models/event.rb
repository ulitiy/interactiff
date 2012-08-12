class Event
  include Mongoid::Document

  field      :input , type: String

  field      :time  , type: Time
  field      :scope , type: Symbol
  field      :block_type  , type: String
  belongs_to :user, index: true
  belongs_to :team, index: true

  belongs_to :block , class_name: "Block", inverse_of: :events, index: true
  belongs_to :game  , class_name: "Game" , inverse_of: :descendant_events, index: true

  belongs_to :parent, class_name: "Event", inverse_of: :children, index: true
  belongs_to :source, class_name: "Event", inverse_of: :descendants, index: true

  belongs_to :responsible_user, class_name: "User", inverse_of: nil, index: true
  field      :reason, type: String

  attr_accessible :input, :time, :user, :block, :game, :parent, :source, :responsible_user, :reason, :scope, :team, :block_type

  has_many :children, class_name: "Event", inverse_of: :parent
  has_many :descendants, class_name: "Event", inverse_of: :source

  # индексы должны учитывать КАЖДЫЙ запрос
  index time: 1
  index game_id:1, type: 1, scope: 1
  index type: 1, scope: 1

  scope :block_type, ->(type) { where(block_type: type) }
  scope :for_one, ->(user) { where(user_id: user.id,scope: :for_one) }
  scope :for_team, ->(team) { where(scope: :for_team, team_id: (team.is_a?(Moped::BSON::ObjectId) ? team : team.id)) }
  scope :for_all, -> { where(scope: :for_all) }
end
