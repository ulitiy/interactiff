class TaskPassed < Message

  # creates an event with variable value
  def create_event options
    super options.merge variable: task.variable, var_value: options[:input]
  end

  # setter should hit all checkers of the variable
  def blocks_to_hit
    super + (task.variable ? task.variable.checkers : [])
  end

end
