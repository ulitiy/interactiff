class Joygen.Models.NotBlock extends Joygen.Models.Block
  modelName: "not_block"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "NotBlock"
      name: I18n.t("admin.not_block.new")
    )
  icon: "/assets/admin/icons/16/104.png"
  isTarget: -> true
  isSource: -> true
