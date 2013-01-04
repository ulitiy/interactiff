class Joygen.Models.Answer extends Joygen.Models.Block
  modelName: "answer"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Answer"
    )
  icon: "/assets/admin/icons/16/102.png"
  isSource: -> true
  isContainerSource: -> @get("container_source")

  link: ->
    "http://quest.interactiff.net/play/submit?task_id=#{@get('parent_id')}&input=#{@get('digest')}"
