class Joygen.Models.Checker extends Joygen.Models.Block
  modelName: "checker"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Checker"
      name: I18n.t("admin.checker.tool")
    )
  icon: "/assets/admin/icons/16/089.png"
  isSource: -> true

  caption: ->
    @get('expression')
