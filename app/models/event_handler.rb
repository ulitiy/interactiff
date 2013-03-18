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

    # mutex
    # handler
    # force_scope

    # responsible_user
    # reason

  # Sets options
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
    @task_answers||=task.children.where(_type:"Answer").order_by(y:1,x:1)
  end

  # hits the task's first by y right answer
  def input input
    task_answers.to_a.find { |answer| answer.hit(options.merge(input: input)) } if current_task?
  end







  def hint_events
    @hint_events||=task.descendant_events_of type: {"$in"=>["TaskGiven", "Hint"]}, user: user, visit_count: task.visit_count
  end
  def hints_given
    @hints_given||=get_blocks hint_events
  end
  def tasks_given
    @tasks_given||=get_tasks game.descendant_events_of type: "TaskGiven", user: user
  end
  def tasks_passed
    @tasks_passed||=get_tasks game.descendant_events_of type: "TaskPassed", user: user
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
    game.descendant_events.block_type("Answer").where(user_id: user.id).order_by(time: -1).first.input
  end

  # @return [Array] tasks given, but not passed
  def current_tasks
    # @current_tasks||=tasks_given-tasks_passed #not roomed version
    events=game.descendant_events_of type: {"$in"=>["TaskGiven", "TaskPassed"]}, user: user
    # ахуеть магия. Самодельный мапредьюс для получения последнего ивента по каждому заданию, затем выбор только тех, где последний ивент - дано.
    events=events.group_by { |e| e.task_id }.map { |key,arr| arr.sort_by { |e| [e.time,e.id] }.last }.select { |e| e.block_type=="TaskGiven" }
    @current_tasks||=get_tasks events
  end

  # @return [Array] tasks given with additional attribute of passed
  def play_tasks
    @play_tasks||=tasks_given.each do |task|
      task.passed=tasks_passed.include?(task)
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
    @play_tasks,@current_tasks,@task_answers,@hint_events,@hints_given,@tasks_given,@tasks_passed,@games_started,@games_passed=nil
    self
  end

end
