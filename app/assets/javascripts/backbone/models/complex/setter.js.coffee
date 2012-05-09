class Joygen.Models.Setter extends Joygen.Models.Block
  modelName: "setter"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Setter"
      name: I18n.t("admin.setter.tool")
    )
  icon: "/assets/admin/icons/16/051.png"
  isTarget: true
