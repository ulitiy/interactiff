# Event for user/team/all for the block (which is action or potential event)
class Event
  include Mongoid::Document
  extend Enumerize

  field      :input , type: String
  field      :time  , type: Time
  field      :scope , type: String, default: "for_one"
  field      :block_type  , type: String
  field      :visit_count , type: Integer, default: 1
  field      :var_value
  enumerize :scope, in: ["for_one","for_team","for_all"], default: "for_one"

  belongs_to :user, index: true
  belongs_to :team, index: true

  belongs_to :variable, index: true
  belongs_to :row, index: true
  belongs_to :block , class_name: "Block", inverse_of: :events
  belongs_to :game  , class_name: "Game" , inverse_of: :descendant_events
  belongs_to :task  , class_name: "Task" , inverse_of: :descendant_events

  belongs_to :parent, class_name: "Event", inverse_of: :children#, index: true # все равно запрашиваем через source
  belongs_to :source, class_name: "Event", inverse_of: :descendants, index: true

  belongs_to :responsible_user, class_name: "User", inverse_of: nil
  field      :reason, type: String

  attr_accessible :input, :time, :user, :block, :parent, :source, :block_id, :source_id, :parent_id, :user_id, :row, :row_id, :responsible_user, :reason,
                  :scope, :team, :variable, :variable_id, :var_value, :visit_count

  has_many :children, class_name: "Event", inverse_of: :parent
  has_many :descendants, class_name: "Event", inverse_of: :source

  default_scope order_by(time: 1,id:1)

  before_create :set_ids

  # САМОЕ ВАЖНОЕ В ПРОИСВОДИТЕЛЬНОСТИ ДВИЖКА – ЗДЕСЬ, ИНДЕКСЫ. Но надо учитывать уменьшение скорости на вставку.
  index game_id: 1, time: 1, id: 1
  index game_id: 1, block_type: 1, scope: 1, team_id: 1, user_id: 1, visit_count: 1, variable: 1, time: 1
  index task_id: 1, block_type: 1, scope: 1, team_id: 1, user_id: 1, visit_count: 1, variable: 1, time: 1
  index block_id: 1, scope: 1, team_id: 1, user_id: 1, visit_count: 1, variable: 1, time: 1
  index game_id: 1, scope: 1, team_id: 1, user_id: 1, visit_count: 1, variable: 1, time: 1

  scope :block_type, ->(type) { type ? where(block_type: type) : scoped }
  scope "for_one", ->(user) { where(scope: "for_one", user_id: user.id) }
  scope "for_team", ->(team) { where(scope: "for_team", team_id: (team.is_a?(Moped::BSON::ObjectId) ? team : team.id)) }
  scope "for_all", -> { where(scope: "for_all") }
  scope :var, ->(v) { v ? where(variable_id: v.id) : scoped }
  scope :visit_count, ->(vc) { vc ? where(visit_count: vc) : scoped }

  # callback before create, setting ids and block_type
  def set_ids
    self.game_id||=block.game_id
    self.task_id||=block.task_id
    self.block_type||=block.type
  end

  # get events of some type for the user. For list of started and passed games
  def self.of options
    arr=[]
    arr+=Event.block_type(options[:type]).for_one options[:user] if options[:user]
    arr+=Event.block_type(options[:type]).for_team options[:user].team if options[:user] && options[:user].team_id
    arr+=Event.block_type(options[:type]).for_all
  end

end
