class Joygen.Models.Jump extends Joygen.Models.Block
  modelName: "jump"
  mainField: "checkpoint_id"
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
    if @checkpoint()? then @checkpoint().parent().get("name") else @get("name")
