class Clock < Block
  field :time, type: Time
  belongs_to :job, class_name: "Delayed::Job"
  attr_accessible :job, :time

  before_save :set_job

  def set_job
    return if @deep
    @deep=true
    if changed_attributes["time"] || new_record?
	    self.job.delete if self.job
      save
	    self.job=delay(run_at: time, queue: "clock").fire(time:time,scope: :for_all,mutex: true)
	  end
    @deep=false
    true
  end

end
