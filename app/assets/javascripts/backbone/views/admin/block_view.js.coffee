Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.BlockView extends Backbone.View

  template: JST["backbone/templates/admin/block"]

  events:
    "mousedown": "mousedown"
    "dragstop": "dragstop"
    "dragstopchild":"dragstopchild"
    "drag": "drag"
    "dragstart" : "dragstart"
    "destroy": "destroy"
    "click .destroy": "destroyConfirm"
    "dblclick": "dblclick"
    "selectedone" : "selectedone"

  tagName: "div"
  className: "block"

  initialize: ->
    @model.on "change", =>
      jsPlumb.repaint $(@el)

  dblclick: =>
    return unless @model.container?
    router.navigate @model.adminPath(),
      trigger:true

  selectedone: =>
    router.navigate "#{parentId}/#{@model.id}",
      trigger:true
      replace:true
    window.editBlockView=this


  mousedown: =>
    return if $(@el).hasClass("ui-selected")
    fieldView.setSelect($(@el))
    $("#field").trigger('selectablestop')
  dragstop: =>
    selected.trigger("dragstopchild")
  dragstopchild: =>
    @model.setPosition $(@el).css_position()
  dragstart: =>
    window.selected=$('.ui-selected')# unless selected? #т.к. при релоаде остается
    selected.each ->
      $(this).data "originalPosition", $(this).css_position()
  drag: (event,ui,ddl,ddt)=>
    if ddt?
      dt=ddt
      dl=ddl
    else
      dt = ui.position.top - ui.originalPosition.top
      dl = ui.position.left - ui.originalPosition.left
    selected.each ->
      pos=$(this).data "originalPosition"
      newtop=pos.top+dt
      newleft=pos.left+dl
      if newtop>0
        $(this).css top:newtop
      else
        $(this).css top:0
      if newleft>0
        $(this).css left:newleft
      else
        $(this).css left:0
    jsPlumb.repaint selected

  move: (l,t)=>
    Joygen.Views.Admin.BlockView.prototype.dragstart()
    Joygen.Views.Admin.BlockView.prototype.drag(null,null,l,t)
    Joygen.Views.Admin.BlockView.prototype.dragstop()


  destroyConfirm: =>
    return unless confirm(I18n.t("links.sure"))
    router.navigate parentBlock.adminPath(),
      trigger:true
    @destroy()
  destroy: =>
    @model.destroy()
    @remove()
    Backbone.ModelBinding.unbind this
    jsPlumb.removeAllEndpoints @el


#TODO: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#простановка всех эндпоинтов блока, сначала родных, потом дочерних
  makeEndpoints: ()=>
    if @model.isTarget
      @targetEndpoint=jsPlumb.addEndpoint @el,
        hoverPaintStyle:{ fillStyle:"#F00" }
        anchor: "LeftMiddle"
        isTarget: true
      @targetEndpoint.model=@model
      @targetEndpoint.blockView=this
      targetEndpoints.push @targetEndpoint
    if @model.isSource
      @sourceEndpoint=jsPlumb.addEndpoint @el,
        hoverPaintStyle:{ fillStyle:"#F00" }
        anchor: "RightMiddle"
        isSource: true
      @sourceEndpoint.model=@model
      @sourceEndpoint.blockView=this
      @sourceEndpoint.bind 'click', (e1)=>
        floatingToolbarView.show(e1)
      sourceEndpoints.push @sourceEndpoint
    if @model.container?
      @addSources()
      @addTargets()
      m=Math.max @sourceEndpoints.length, @targetEndpoints.length
      $(@el).css("min-height",m*14)

#простановка дочерних
  addSources: ()=>
    arr=@model.getContainerSources()
    i=0
    @sourceEndpoints=_.map arr, (block)=>
      e=jsPlumb.addEndpoint @el,
        hoverPaintStyle:{ fillStyle:"#F00" }
        anchor:[1,(++i)/(arr.length+1),1,0]
        isSource: true
      e.model=block
      e.blockView=this
      e.bind 'click', (e1)=>
        floatingToolbarView.show(e1)
      $(e.canvas).append "<div class=\"sourceTitle\">#{block.endpointCaption()}</div>"
      sourceEndpoints.push e #window
      e

#то же
  addTargets: ()=>
    arr=@model.getContainerTargets()
    i=0
    @targetEndpoints=_.map arr, (block)=>
      e=jsPlumb.addEndpoint @el,
        hoverPaintStyle:{ fillStyle:"#F00" }
        anchor:[0,(++i)/(arr.length+1),-1,0]
        isTarget: true
      e.model=block
      e.blockView=this
      $(e.canvas).append "<div class=\"targetTitle\">#{block.endpointCaption()}</div>"
      targetEndpoints.push e #window
      e



  render: =>
    $(@el).data("view",this) #круто!
    $(@el).html @template(@model)
    $(@el).attr("title",I18n.t('admin.'+@model.modelName+'.hint'))
    $(@el).css(left:"#{@model.get("x")}px",top:"#{@model.get("y")}px")
    jsPlumb.draggable $(@el)
    $(@el).draggable("option","containment","parent")
    $(@el).draggable("option","delay",200)
    $(@el).draggable("option","distance",gridStep)
    $(@el).draggable("option","grid",[gridStep,gridStep])
    Backbone.ModelBinding.bind(this);
    this
