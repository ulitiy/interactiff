class Joygen.Models.Answer extends Joygen.Models.Block
  modelName: "answer"
  mainField: "body"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Answer"
      message_type: "success"
    )
  icon: "/assets/admin/icons/16/102.png"
  isSource: -> true

  link: ->
    "https://interactiff.net/play/submit?task_id=#{@get('parent_id')}&input=#{@get('digest')}"
