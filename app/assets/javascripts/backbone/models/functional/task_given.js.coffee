class Joygen.Models.TaskGiven extends Joygen.Models.Block
  modelName: "task_given"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "TaskGiven"
      name: I18n.t("admin.task_given.new")
    )
  icon: "/assets/admin/icons/16/143.png"
  isSource: -> true
  isContainerTarget: -> true
  deletable: false
