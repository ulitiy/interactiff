Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.TargetView extends Backbone.View

  template: JST["backbone_admin/templates/admin/target"]

  render: ->
    @endpoint=jsPlumb.addEndpoint @options.blockView.el,
      hoverPaintStyle:{ fillStyle:"#89C27F" }
      anchor: @options.anchor
      isTarget: true
      # endpoint: [ "Image", { src:"http://morrisonpitt.com/jsPlumb/img/endpointTest1.png" } ]
    @endpoint.view=this
    @bindCT() if parentTask?
    @bindDropConnection()
    if @options.blockView.model.modelName=="task"
      $(@endpoint.canvas).append @template(@model)
      rivets.bind $(@endpoint.canvas), { model: @model }


  bindCT: =>
    $(@endpoint.canvas).attr("data-class-containertarget","model.container_target")
    @endpoint.bind 'dblclick', =>
      @model.set("container_target", !@model.get("container_target"))
      @model.save()
    rivets.bind $(@endpoint.canvas), { model: @model }

  bindDropConnection: =>
    @endpoint.bind 'click', =>
      return unless dragConnectionFrom?
      relView=new Joygen.Views.Admin.RelationView
        sourceView:dragConnectionFrom
        targetView:this
      relView.createModel()
      relView.render()
      $(dragConnectionFrom.endpoint.canvas).removeClass "dcf"
      window.dragConnectionFrom=null


# $(e.canvas).append "<div class=\"sourceTitle\">#{block.endpointCaption()}</div>"

