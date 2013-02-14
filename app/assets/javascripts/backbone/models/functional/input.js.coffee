class Joygen.Models.Input extends Joygen.Models.Block
  modelName: "input"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Input"
      name: I18n.t("admin.input.new")
      container_target: true
    )
  icon: "/assets/admin/icons/16/131.png"
  isSource: -> true
