class EventHandler
  attr_accessor :options

  # Sets options
  def initialize opt
    @options=opt
    #game necessary
  end

  # hits the block with options
  def hit block
    block.hit(options)
  end

  def is_hit? block
    block.is_hit? options
  end

  # @return [Array] all task's answers ordered by y
  def task_answers
    options[:task].children.where(_type:"Answer").order_by(y:1,x:1)
  end

  # hits the task's first by y right answer
  def input input
    task_answers.to_a.find { |answer| answer.hit(options.merge(input: input)) }
  end


  # TODO: ТРЕБУЕТСЯ ЖЕСТОКИЙ РЕФАКТОРИНГ
  # @return [Array] tasks given
  def tasks_given
    tgs=options[:game].descendant_events.block_type("TaskGiven").for_one options[:user]
    tgs+=options[:game].descendant_events.block_type("TaskGiven").for_team options[:user].team_id if options[:user].team_id
    tgs+=options[:game].descendant_events.block_type("TaskGiven").for_all
    get_tasks tgs
  end
  # @return [Array] tasks passed
  def tasks_passed
    tgs=options[:game].descendant_events.block_type("TaskPassed").for_one options[:user]
    tgs+=options[:game].descendant_events.block_type("TaskPassed").for_team options[:user].team_id if options[:user].team_id
    tgs+=options[:game].descendant_events.block_type("TaskPassed").for_all
    get_tasks tgs
  end
  # @return [Array] games started
  def games_started
    tgs=Event.block_type("GameStarted").for_one options[:user]
    tgs+=Event.block_type("GameStarted").for_team options[:user].team_id if options[:user].team_id
    tgs+=Event.block_type("GameStarted").for_all
    get_games tgs
  end
  # @return [Array] games passed
  def games_passed
    tgs=Event.block_type("GamePassed").for_one options[:user]
    tgs+=Event.block_type("GamePassed").for_team options[:user].team_id if options[:user].team_id
    tgs+=Event.block_type("GamePassed").for_all
    get_games tgs
  end
  # @return [Array] tasks for the functional blocks
  # @param [Array] fun an array of the functional blocks
  def get_tasks fun
    fun_ids=fun.map &:block_id
    t_ids=Block.find(fun_ids).map &:task_id
    Block.find(t_ids)
  end
  # @return [Array] games for the functional blocks
  # @param [Array] fun an array of the functional blocks
  def get_games fun
    fun_ids=fun.map &:block_id
    g_ids=Block.find(fun_ids).map &:game_id
    Block.find(g_ids)
  end


  # @return [Array] tasks given, but not passed
  def tasks_available
    tasks_given-tasks_passed
  end

  # TODO: переписать! неоптимально! 5 запросов вместо 4? Может забить?
  def task_passed?
    options[:task].in? tasks_passed
  end

end