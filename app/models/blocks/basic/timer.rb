class Timer < Block
  field :time, type: Float, default: 0

  attr_accessible :time

  def time= var
    write_attribute(:time,var) && return unless var.is_a? String
    hms=var.split(":")
    write_attribute :time, hms[0].to_i*3600+hms[1].to_i*60+hms[2].to_i
  end

  # return string of time in hms format
  def time_to_hms
    t=self.time.to_i
    h=t/3600
    t%=3600
    m=t/60
    t%=60
    "#{h}:#{m}:#{t}"
  end

  # Overriden as_json adding type and id fields
  def as_json options={}
    json=super options
    json["time"]=time_to_hms
    json
  end


  #проблема в том, что dj не работает с несохраненными моделями
  def block_actions options
    options.delete :time
    delay(run_at: time.from_now, queue: "clock").hit_relations_timer(options.merge(mutex: true, handler: nil))
  end

  # replace default behaviour
  alias hit_relations_timer hit_relations

  def hit_relations options ;[] end

end
