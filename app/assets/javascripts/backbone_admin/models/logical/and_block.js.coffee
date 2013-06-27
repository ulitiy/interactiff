class Joygen.Models.AndBlock extends Joygen.Models.Block
  modelName: "and_block"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "AndBlock"
      name: I18n.t("admin.and_block.new")
    )
  icon: "/assets/admin/icons/16/101.png"
  isTarget: -> true
  isSource: -> true
