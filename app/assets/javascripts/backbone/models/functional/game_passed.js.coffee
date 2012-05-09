class Joygen.Models.GamePassed extends Joygen.Models.Block
  modelName: "game_passed"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "GamePassed"
      name: I18n.t("admin.game_passed.new")
    )
  icon: "/assets/admin/icons/16/137.png"
  isSource: true
  isTarget: true
  deletable: false
