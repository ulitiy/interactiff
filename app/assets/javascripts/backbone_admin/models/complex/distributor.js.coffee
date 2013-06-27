class Joygen.Models.Distributor extends Joygen.Models.Block
  modelName: "distributor"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Distributor"
      name: I18n.t("admin.distributor.tool")
    )
  icon: "/assets/admin/icons/16/083.png"
  isSource: -> true
  isTarget: -> true
