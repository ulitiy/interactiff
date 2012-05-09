class Joygen.Models.Hint extends Joygen.Models.Block
  modelName: "hint"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Hint"
      body: I18n.t("admin.hint.new")
    )
  icon: "/assets/admin/icons/16/022.png"
  isTarget: true
