class Joygen.Models.Clock extends Joygen.Models.Block
  modelName: "clock"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Clock"
      name: I18n.t("admin.clock.tool")
    )
  icon: "/assets/admin/icons/16/087.png"
  isSource: -> true
