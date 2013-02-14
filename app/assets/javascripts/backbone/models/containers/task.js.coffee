class Joygen.Models.Task extends Joygen.Models.Block
  modelName: "task"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Task"
      name: I18n.t("admin.task.new")
    )
  container: -> true
  tools: ['Hint', 'Answer', 'Clock', 'Timer', 'AndBlock', 'OrBlock', "Setter", "Checker"]
  icon: "/assets/admin/icons/16/071.png"
  save: (attributes, options) =>
    if @isNew()
      hash=
        success: =>
          taskGiven=new Joygen.Models.TaskGiven({parent_id:@id, x:0, y: 100})
          taskPassed=new Joygen.Models.TaskPassed({parent_id:@id, x:600, y: 100})
          masterCollection.create(taskGiven)
          masterCollection.create(taskPassed)
          fieldView.render() #TODO
    super attributes, $.extend(options, hash)
