class Joygen.Models.Checkpoint extends Joygen.Models.Block
  modelName: "checkpoint"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Checkpoint"
      name: I18n.t("admin.checkpoint.new")
    )
  icon: "/assets/admin/icons/16/107.png"
  isSource: -> true
