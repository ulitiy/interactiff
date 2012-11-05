class Joygen.Models.Game extends Joygen.Models.Block
  modelName: "game"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Game"
      name: I18n.t("admin.game.new")
    )
  container: true
  tools: ["Task", "Message", 'Clock', 'Timer', 'AndBlock', 'OrBlock', 'Setter', 'Checker', 'Distributor', "Input", "Output"]
  icon: "/assets/admin/icons/16/069.png"
  save: (attributes, options) =>
    if @isNew()
      hash=
        success: =>
          gameStarted=new Joygen.Models.GameStarted({parent_id:@id, x:0, y: 100})
          gameStarted.save()
          gamePassed=new Joygen.Models.GamePassed({parent_id:@id, x:600, y: 100})
          gamePassed.save()
          masterCollection.add([gameStarted,gamePassed])
          fieldView.render() #TODO
    super attributes, $.extend(options, hash)
