class Joygen.Models.ElseBlock extends Joygen.Models.Block
  modelName: "else_block"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "ElseBlock"
      name: I18n.t("admin.else_block.tool")
    )
  icon: "/assets/admin/icons/16/088.png"
  isSource: -> true
  isTarget: -> true
