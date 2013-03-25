class Joygen.Models.Jump extends Joygen.Models.Block
  modelName: "jump"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Jump"
      name: I18n.t("admin.jump.new")
    )
  icon: "/assets/admin/icons/16/108.png"
  isTarget: -> true

  checkpoints: ->
    parentBlock.checkpoints()

  checkpoint: ->
    @collection.get(@get("checkpoint_id"))

  caption: ->
    n=if @checkpoint()? then @checkpoint().get("name") else @get("name")
    n=n.replace(/(<([^>]+)>)/ig,"") #strip html
    return n if n? && n.length <= 20
    n.substr(0,17)+"..." if n?
