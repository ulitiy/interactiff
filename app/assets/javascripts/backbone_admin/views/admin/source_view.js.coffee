Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.SourceView extends Backbone.View

  template: JST["backbone_admin/templates/admin/source"]

  # endpoint===el

  render: ->
    @endpoint=jsPlumb.addEndpoint @options.blockView.el,
      hoverPaintStyle:{ fillStyle:"#89C27F" }
      anchor: @options.anchor
      isSource: true
    @endpoint.view=this
    @bindCS() if parentTask?
    @bindDragConnection()
    if @options.blockView.model.modelName=="task"
      $(@endpoint.canvas).append @template(@model)
      rivets.bind $(@endpoint.canvas), { model: @model }

  addRelations: ->
    _.each @model.outRelations(), (relation)=> #берем все исходящие стрелки из ep
      targetView=_.find targetViews, (e)-> #ищем среди текущих tep
        e.model.id==relation.get("to_id") #ту, в которую приходит стрелка
      if targetView
        relView=new Joygen.Views.Admin.RelationView
          model:relation
          sourceView:this
          targetView:targetView
        relView.render()

  bindCS: =>
    $(@endpoint.canvas).attr("data-class-containersource","model.container_source")
    @endpoint.bind 'dblclick', =>
      # return unless @model.get("task_id")?
      $(dragConnectionFrom.endpoint.canvas).removeClass "dcf" if dragConnectionFrom?
      window.dragConnectionFrom=null
      @model.set("container_source", !@model.get("container_source"))
      @model.save()

  bindDragConnection: =>
    @endpoint.bind 'click', =>
      $(dragConnectionFrom.endpoint.canvas).removeClass "dcf" if dragConnectionFrom?
      window.dragConnectionFrom=this
      $(@endpoint.canvas).addClass "dcf"

# @endpoint.bind 'click', (e1)=>
#   floatingToolbarView.show(e1)
