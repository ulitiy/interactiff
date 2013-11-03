class Joygen.Models.AddRowBlock extends Joygen.Models.Block
  modelName: "add_row_block"
  mainField: "expression"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "AddRowBlock"
      name: I18n.t("admin.add_row_block.tool")
    )
  icon: "/assets/admin/icons/16/080.png"
  isTarget: -> true

  caption: ->
    @get('expression')

  save: (attributes, options) =>
    @set("exception",null)
    super attributes, options
