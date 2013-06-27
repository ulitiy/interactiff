class Joygen.Models.Clock extends Joygen.Models.Block
  modelName: "clock"
  mainField: "time"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Clock"
    )
  icon: "/assets/admin/icons/16/087.png"
  isSource: -> true

  caption: ->
    @get('time')
