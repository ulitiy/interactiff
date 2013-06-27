class Joygen.Models.Condition extends Joygen.Models.Block
  modelName: "condition"
  mainField: "expression"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Condition"
      name: I18n.t("admin.condition.tool")
    )
  icon: "/assets/admin/icons/16/089.png"
  isSource: -> true
  isTarget: -> true

  caption: ->
    @get('expression')

  save: (attributes, options) =>
    @set("exception",null)
    super attributes, options
