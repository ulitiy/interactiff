class Joygen.Models.OrBlock extends Joygen.Models.Block
  modelName: "or_block"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "OrBlock"
      name: I18n.t("admin.or_block.new")
    )
  icon: "/assets/admin/icons/16/103.png"
  isTarget: -> true
  isSource: -> true
