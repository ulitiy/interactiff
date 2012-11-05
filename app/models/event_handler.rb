class EventHandler
  attr_accessor :options

  # Sets options
  def initialize opt
    @options=opt
    @options[:game]=@options[:task].parent if !@options[:game]
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
    @task_answers||=options[:task].children.where(_type:"Answer").order_by(y:1,x:1)
  end

  # hits the task's first by y right answer
  def input input
    task_answers.to_a.find { |answer| answer.hit(options.merge(input: input)) } if task_given?
  end








  def hint_events
    @hint_events||=options[:task].descendant_events_of type: "Hint", user: options[:user]
  end
  def hints_given
    @hints_given||=get_blocks hint_events
  end
  def tasks_given
    @tasks_given||=get_tasks options[:game].descendant_events_of type: "TaskGiven", user: options[:user]
  end
  def tasks_passed
    @tasks_passed||=get_tasks options[:game].descendant_events_of type: "TaskPassed", user: options[:user]
  end
  def games_started
    @games_started||=get_games Event.of type: "GameStarted", user: options[:user]
  end
  def games_passed
    @games_passed||=get_games Event.of type: "GamePassed", user: options[:user]
  end
  # @return [Array] hints for the functional blocks
  # @param [Array] fun an array of the functional blocks
  def get_blocks fun
    ids=fun.map &:block_id
    Block.find(ids)
  end
  # @return [Array] tasks for the functional blocks
  # @param [Array] fun an array of the functional blocks
  def get_tasks fun
    ids=get_blocks(fun).map &:task_id
    Block.find(ids)
  end
  # @return [Array] games for the functional blocks
  # @param [Array] fun an array of the functional blocks
  def get_games fun
    ids=get_blocks(fun).map &:game_id
    Block.find(ids)
  end


  # @return [Array] tasks given, but not passed
  def current_tasks
    tasks_given-tasks_passed
  end

  # @return [Array] tasks given with additional attribute of passed
  def play_tasks
    tasks_given.each do |task|
      task.passed=tasks_passed.include?(task)
    end
  end

  def task_given?
    options[:task].in? tasks_given
  end

  def task_passed?
    options[:task].in? tasks_passed
  end

  def game_passed?
    options[:game].in? games_passed
  end

  def flush
    @task_answers=@hint_events=@hints_given=@tasks_given=@tasks_passed=@games_started=@games_passed=nil
    self
  end

end
