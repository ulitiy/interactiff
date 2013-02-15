class ActiveSupport::TimeWithZone
  def as_json(options = nil)
    time.strftime "%Y-%m-%d %H:%M:%S"
  end
end
