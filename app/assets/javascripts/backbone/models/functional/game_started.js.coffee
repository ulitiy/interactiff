class Joygen.Models.GameStarted extends Joygen.Models.Block
  modelName: "game_started"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "GameStarted"
      name: I18n.t("admin.game_started.new")
    )
  icon: "/assets/admin/icons/16/143.png"
  isSource: -> true
  isTarget: -> true
  deletable: false
