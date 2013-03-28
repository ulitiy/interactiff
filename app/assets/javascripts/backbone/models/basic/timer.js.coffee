class Joygen.Models.Timer extends Joygen.Models.Block
  modelName: "timer"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Timer"
    )
  icon: "/assets/admin/icons/16/052.png"
  isSource: -> true
  isTarget: -> true

  caption: ->
    @get('time')
