Joygen.Views.Admin ||= {}

jsPlumb.bind "beforeDetach", ->
  jsPlumb.allowDetach
jsPlumb.bind "beforeDrop", ->
  manage

jsPlumb.bind "connection", (e)->
  return if jsPlumb.silent
  view=new Joygen.Views.Admin.RelationView
    sourceView: e.sourceEndpoint.view
    targetView: e.targetEndpoint.view
  view.connection=e.connection
  view.render()
  view.createModel()
jsPlumb.bind "beforeDetach", ->
  return jsPlumb.allowDetach

class Joygen.Views.Admin.RelationView extends Backbone.View
  createModel: =>
    @model=relationsCollection.create
      from_id:@options.sourceView.model.id
      to_id:@options.targetView.model.id

  prepare: =>
    @connection.bind "click", =>
      return unless manage && confirm(I18n.t("admin.links.sure"))
      @model.destroy()
      jsPlumb.allowDetach=true
      jsPlumb.detach @connection
      jsPlumb.allowDetach=false
    @connection.view=this

  render: =>
    jsPlumb.silent=true
    jsPlumb.allowDetach=true
    jsPlumb.detach @connection if @connection #тут проблема в 1.5.2 jsplumb
    jsPlumb.allowDetach=false
    @connection=jsPlumb.connect
      source:@options.sourceView.endpoint
      target:@options.targetView.endpoint
      paintStyle:
        lineWidth:1.2
        strokeStyle:"##{$.random(0,9)}#{$.random(0,9)}#{$.random(0,9)}"
      connector: if @options.sourceView.endpoint.element.context==@options.targetView.endpoint.element.context then "Flowchart" else "Bezier"
    # @connection.applyType
    #   connector:"straight"
    #   paintStyle:
    #     lineWidth:1.2
    #     strokeStyle:"##{$.random(0,9)}#{$.random(0,9)}#{$.random(0,9)}"
    @prepare()
    jsPlumb.silent=false
