class Clock < Block
  field :time, type: Time
  belongs_to :job, class_name: "Delayed::Job"
  attr_accessible :job, :time

  before_save :set_job

  def set_job
    self.job.delete if self.job
    self.job=delay(run_at: time, queue: "clock").fire(time:time)
  end

end
