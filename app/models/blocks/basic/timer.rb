class Timer < Block
  field :time, type: Float

  #проблема в том, что dj не работает с несохраненными моделями
  def block_actions options
    delay(run_at: time.from_now, queue: "clock").hit_relations_timer(options.merge(mutex: true))
  end

  # replace default behaviour
  alias hit_relations_timer hit_relations

  def hit_relations options ;[] end

end
