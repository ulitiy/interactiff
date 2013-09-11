class Joygen.Models.Answer extends Joygen.Models.Block
  modelName: "answer"
  mainField: "body"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Answer"
      message_type: "success"
      container_source: true
    )
  icon: "/assets/admin/icons/16/102.png"
  isSource: -> true

  link: ->
    "https://interactiff.net/play/submit?task_id=#{@get('parent_id')}&input=#{@get('digest')}"

  show_spelling_matters: ->
    @get("reusable")=="no"

  save: (attributes, options) =>
    if @isNew()
      hash=
        success: =>
          relationsCollection.create
            from_id: @id
            to_id: masterCollection.findWhere
              parent_id: @parent().id
              type: "TaskPassed"
            .id
    super attributes, $.extend(options, hash)
