class Joygen.Models.Game extends Joygen.Models.Block
  modelName: "game"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Game"
      name: I18n.t("admin.game.new")
    )
  container: -> true
  tools: ["Task", 'Message', 'Clock', 'Timer', 'AndBlock', 'OrBlock', 'Distributor', 'Jump', "Setter", "Condition", "ElseBlock", "Checker", "AddRowBlock", "RequestBlock"]
  icon: "/assets/admin/icons/16/069.png"

  checkpoints: =>
    @collection.filter (block)=>
      block.get("type")=="TaskGiven"
