class Clock < Block
  field :time, type: Time
  belongs_to :job, class_name: "Delayed::Job", dependent: :destroy
  attr_accessible :job, :time

  before_save :set_job
  skip_callback :save, :before, :set_job, if: -> { @skip_set_job }

  # Set the delayed job at the specified time
  def set_job
    self.time=1.month.from_now if time.blank?
    @skip_set_job=true
    if changed_attributes["time"] || new_record?
      self.job.delete if self.job
      save if new_record?
      self.job=delay(run_at: time, queue: "clock").fire(time:time,scope: :for_all,mutex: true)
    end
    !@skip_set_job=false
  end

end
