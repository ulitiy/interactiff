class Task < Block
  field :name, type: String, :default => ""
  field :input_type, type: String, :default => "link"
  field :show_wrong_answer, type: Boolean, default: true
  field :order, type: Integer, default: 1000
  field :expression, type: String, default: ""
  field :pass_default, type: Boolean, default: true

  belongs_to :variable, class_name: "Variable", inverse_of: nil, index: true

  has_many :descendants, class_name: 'Block', inverse_of: :task
  has_many :descendant_events, class_name: 'Event', inverse_of: :task
  attr_accessible :name, :input_type, :show_wrong_answer, :order, :expression, :pass_default
  attr_accessor :passed #event_handler.rb #88
  attr_accessor :visit_count, :tge, :tpe
  before_save :set_variable

  # sets variable from the expression
  def set_variable
    self.variable=expression.present? ? Variable.find_or_create_by(game: game, name: expression) : nil
  end

  def load_rooms options
    @tge=descendant_events.of(options.merge(type: "TaskGiven")).sort_by { |e| [e.time,e.id] }.last
    @tpe=descendant_events.of(options.merge(type: "TaskPassed")).sort_by { |e| [e.time,e.id] }.last
    @visit_count=(tge ? tge.visit_count : 0)
    @passed=(tpe && visit_count==tpe.visit_count)
  end

  def rooms_loaded?
    visit_count.present?
  end

  def given_block
    children.where(_type: "TaskGiven").first
  end

  def passed_block
    children.where(_type: "TaskPassed").first
  end

  def answers
    children.where(_type:"Answer").order_by(y:1,x:1)
  end

  def get_redirect_event options
    descendant_events.of(options.merge(type: "RedirectBlock")).sort_by { |e| [e.time,e.id] }.last
  end

  def input_default options
    passed_block.hit(options).compact
  end

end
