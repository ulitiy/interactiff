Joygen.Views.Admin ||= {}

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
    tmpcon=@connection
    setTimeout ->  #т.к. проблема в 1.5.2 jsplumb
      jsPlumb.allowDetach=true
      jsPlumb.detach tmpcon if tmpcon
      jsPlumb.allowDetach=false
    @connection=jsPlumb.connect
      source:@options.sourceView.endpoint
      target:@options.targetView.endpoint
      paintStyle:
        lineWidth:1.2
        strokeStyle:"##{$.random(0,9)}#{$.random(0,9)}#{$.random(0,9)}"
      connector: if @options.sourceView.endpoint.element==@options.targetView.endpoint.element then "Flowchart" else "Bezier" #.context if <1.5
    # @connection.applyType
    #   connector:"straight"
    #   paintStyle:
    #     lineWidth:1.2
    #     strokeStyle:"##{$.random(0,9)}#{$.random(0,9)}#{$.random(0,9)}"
    @prepare()
    jsPlumb.silent=false
