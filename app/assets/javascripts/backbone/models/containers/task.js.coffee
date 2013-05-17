class Joygen.Models.Task extends Joygen.Models.Block
  modelName: "task"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Task"
      name: I18n.t("admin.task.new")
    )
  container: -> true
  tools: ['Hint', 'Answer', 'Message', 'Clock', 'Timer', 'AndBlock', 'OrBlock', "Setter", "Condition", "Checker", "RequestBlock", "RedirectBlock"]
  icon: "/assets/admin/icons/16/071.png"
  save: (attributes, options) =>
    if @isNew()
      hash=
        success: =>
          taskGiven=new Joygen.Models.TaskGiven({parent_id:@id, x:50, y: 50})
          taskPassed=new Joygen.Models.TaskPassed({parent_id:@id, x:800, y: 500})
          masterCollection.create(taskGiven)
          masterCollection.create(taskPassed)
          fieldView.render() #TODO
    super attributes, $.extend(options, hash)
