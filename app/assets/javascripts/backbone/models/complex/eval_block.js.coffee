class Joygen.Models.EvalBlock extends Joygen.Models.Block
  modelName: "eval_block"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "EvalBlock"
      name: I18n.t("admin.eval_block.tool")
    )
  icon: "/assets/admin/icons/16/146.png"
  isSource: -> true
  isTarget: -> true
