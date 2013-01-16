class Clock < Block
  field :time, type: Time
  belongs_to :job, class_name: "Delayed::Job", dependent: :destroy
  attr_accessible :job, :time

  before_save :set_time
  after_save :set_job
  skip_callback :save, :after, :set_job, if: -> { @skip_set_job }

  def set_time
    self.time=1.month.from_now if time.blank?
  end

  # TODO: WTF?
  # Set the delayed job at the specified time
  def set_job
    @skip_set_job=true
    self.job.destroy if self.job
    save! && reload
    self.job=delay(run_at: time, queue: "clock").fire(time:time,scope: :for_all,mutex: true)
    !@skip_set_job=false
  end

end
