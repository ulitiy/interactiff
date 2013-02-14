class Joygen.Models.TaskGiven extends Joygen.Models.Block
  modelName: "task_given"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "TaskGiven"
      body: I18n.t("admin.task_given.new")
      title: I18n.t("admin.task_given.new")
      container_target: true
    )
  icon: "/assets/admin/icons/16/143.png"
  isSource: -> true
  isContainerTarget: -> true
  deletable: false
