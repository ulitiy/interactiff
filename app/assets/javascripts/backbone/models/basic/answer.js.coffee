class Joygen.Models.Answer extends Joygen.Models.Block
  modelName: "answer"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Answer"
    )
  icon: "/assets/admin/icons/16/102.png"
  isSource: true
  initialize: ->
    super
    @on "change:id", =>
      @set "link": @getLink()
    setTimeout => @set "link": @getLink()
    ,0

  getLink: ->
    "http://quest.interactiff.net/play/sumbit?task_id=#{@get('parent_id')}&input=#{@get('digest')}"
