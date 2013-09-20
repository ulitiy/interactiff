class TaskPassed < Message

  # creates an event with variable value
  def create_event options
    options[:handler]||=EventHandler.new user: options[:user], game: options[:game], task: options[:task] #TODO: test
    super options.merge variable: task.variable, var_value: options[:handler].last_answer # TODO: плохо?
  end

end
