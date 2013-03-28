class Joygen.Models.TaskPassed extends Joygen.Models.Block
  modelName: "task_passed"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "TaskPassed"
      name: I18n.t("admin.task_passed.new")
      container_source: true
      message: I18n.t("admin.task_passed.message")
      message_type: "success"
    )
  icon: "/assets/admin/icons/16/137.png"
  isTarget: -> true
  isContainerSource: -> true
  deletable: false
