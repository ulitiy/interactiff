class TaskGiven < Hint
  def create_event options
    task.load_rooms(options)
    task.visit_count=(task.passed ? task.visit_count+1 : task.visit_count)
    task.visit_count=1 if task.visit_count==0
    task.passed=false
    super options
  end
end
