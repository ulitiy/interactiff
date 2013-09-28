class TaskPassed < Message

  # creates an event with variable value
  def create_event options
    super options.merge variable: task.variable, var_value: options[:input]
  end

end
