class EventHandler
  attr_accessor :options, :game, :task, :user, :input

  # options:
    # scope
    # game
    # task
    # user
    # parent
    # source
    # time
    # input
    # var 2

    # mutex
    # handler
    # force_scope

    # responsible_user
    # reason

  # Sets options
  # Reliable options are necessary
  def initialize opt
    @options=opt
    @options[:game] ||= @options[:task].parent
    @game=@options[:game]
    @task=@options[:task]
    @user=@options[:user]
    @options[:handler]=self
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
    @task_answers||=task.answers
  end

  # hits the task's first by y right answer
  def input input
    if current_task?
      options.merge!(input: input)
      task_answers.to_a.find { |answer| @events=answer.hit(options) }
      return @events.compact if @events
      @task.input_default(options) if @task.input_type=="text" && @task.pass_default
    end
  end





  def hint_events
    task.load_rooms(options) unless task.rooms_loaded?
    @hint_events||=task.descendant_events_of type: {"$in"=>Hint.descendant_types}, user: user, visit_count: task.visit_count
  end
  def hints_given
    @hints_given||=get_blocks hint_events
  end
  def tasks_given
    @tasks_given||=get_tasks game.descendant_events_of type: "TaskGiven", user: user
  end
  def tasks_passed
    @tasks_passed||=get_tasks task_events.select { |e| e.block_type=="TaskPassed" }
  end
  def games_started
    @games_started||=get_games Event.of type: "GameStarted", user: user
  end
  def games_passed
    @games_passed||=get_games Event.of type: "GamePassed", user: user
  end
  # @return [Array] blocks for events
  # @param [Array] fun an array of events
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


  # @return String last answer
  def last_answer
    game.descendant_events.block_type("Answer").where(user_id: user.id).order_by(time: -1).first.try(:input)
  end

  # @return [Array] tasks given, but not passed
  def current_tasks
    @current_tasks||=get_tasks task_events.select { |e| e.block_type=="TaskGiven" }
  end

  # get last functional events for game tasks and current user
  # GREAT MAGIC!
  def task_events
    @task_events||=game.descendant_events_of(type: {"$in"=>["TaskGiven", "TaskPassed"]}, user: user).
              group_by(&:task_id).map { |key,arr| arr.sort_by { |e| [e.time,e.id] }.last }
  end

  # @return [Array] tasks given with additional attribute of passed
  def play_tasks
    @play_tasks||=task_events.map do |e|
      e.task.passed=(e.block_type=="TaskPassed")
      e.task
    end
  end

  def task_given?
    task.in? tasks_given
  end

  def task_passed?
    task.in? tasks_passed
  end

  # if the task is given, but not passed
  def current_task?
    task.in? current_tasks
  end

  def game_passed?
    game.descendant_events_of(type: "GamePassed",user: user).any?
  end

  def game_started?
    game.descendant_events_of(type: "GameStarted",user: user).any?
  end

  def flush
    @play_tasks,@current_tasks,@task_answers,@hint_events,@hints_given,@tasks_given,@tasks_passed,@games_started,@games_passed,@task_events=nil
    self
  end

end
