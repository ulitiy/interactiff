class Task < Block
  field :name, type: String, :default => ""
  field :input_type, type: String, :default => "text"
  field :show_wrong_answer, type: Boolean, default: true

  has_many :descendants, class_name: 'Block', inverse_of: :task
  has_many :descendant_events, class_name: 'Event', inverse_of: :task
  attr_accessible :name, :input_type, :show_wrong_answer
  attr_accessor :passed #event_handler.rb #88
  attr_accessor :visit_count, :tge, :tpe

  def load_rooms options
    @tge=descendant_events.of(options.merge(type: "TaskGiven")).sort_by { |e| [e.time,e.id] }.last
    @tpe=descendant_events.of(options.merge(type: "TaskPassed")).sort_by { |e| [e.time,e.id] }.last
    @visit_count=(tge ? tge.visit_count : 0)
    @passed=(tpe && visit_count==tpe.visit_count)
  end

  def rooms_loaded?
    visit_count.present?
  end

  def get_redirect_event options
    descendant_events.of(options.merge(type: "RedirectBlock")).sort_by { |e| [e.time,e.id] }.last
  end
end
