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
    "doubletap": "dblclick"
    "selectedone" : "selectedone"

  tagName: "div"
  className: "block"

  initialize: ->
    @model.on "change", =>
      jsPlumb.repaint $(@el)

  dblclick: =>
    propertiesView.setFocus()
    return unless @model.container?
    router.navigate @model.adminPath(),
      trigger:true

  selectedone: =>
    router.navigate "#{parentId}/#{@model.id}",
      trigger:true
      replace:true
    # window.editBlockView=this


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
    return false unless manage
    Joygen.Views.Admin.BlockView.prototype.dragstart()
    Joygen.Views.Admin.BlockView.prototype.drag(null,null,l,t)
    Joygen.Views.Admin.BlockView.prototype.dragstop()


  destroyConfirm: =>
    return if !manage || !confirm(I18n.t("admin.links.sure"))
    router.navigate parentBlock.adminPath(),
      trigger:true
    @destroy()
  destroy: =>
    @model.destroy()
    @remove()
    @rivestView.unbind()
    jsPlumb.removeAllEndpoints @el


#TODO: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#простановка всех эндпоинтов блока, сначала родных, потом дочерних
  makeEndpoints: ()=>
    if @model.isTarget?()
      @targetEndpoint=jsPlumb.addEndpoint @el,
        hoverPaintStyle:{ fillStyle:"#89C27F" }
        anchor: "LeftMiddle"
        isTarget: true
        # endpoint: [ "Image", { src:"http://morrisonpitt.com/jsPlumb/img/endpointTest1.png" } ]
      @targetEndpoint.model=@model
      @targetEndpoint.blockView=this
      @bindTarget(@targetEndpoint)
      # @targetEndpoint.bind 'click', ()=>

      targetEndpoints.push @targetEndpoint
    if @model.isSource?()
      @sourceEndpoint=jsPlumb.addEndpoint @el,
        hoverPaintStyle:{ fillStyle:"#89C27F" }
        anchor: "RightMiddle"
        isSource: true
      @sourceEndpoint.model=@model
      @sourceEndpoint.blockView=this
      @bindSource(@sourceEndpoint)
      # @sourceEndpoint.bind 'click', (e1)=>
      #   floatingToolbarView.show(e1)
      sourceEndpoints.push @sourceEndpoint
    if @model.container?()
      @addSources()
      @addTargets()
      m=Math.max @sourceEndpoints.length, @targetEndpoints.length
      $(@el).css("min-height",m*14)
      jsPlumb.repaint $(@el)


  bindSource: (s)=>
    s.bind 'click', =>
      $(dragConnectionFrom.canvas).removeClass "dcf" if dragConnectionFrom?
      window.dragConnectionFrom=s
      $(s.canvas).addClass "dcf"
  bindTarget: (t)=>
    t.bind 'click', =>
      return unless dragConnectionFrom?
      relView=new Joygen.Views.Admin.RelationView
        sourceEndpoint:dragConnectionFrom
        targetEndpoint:t
      relView.createModel()
      relView.render()
      $(dragConnectionFrom.canvas).removeClass "dcf"
      window.dragConnectionFrom=null


#простановка дочерних
  addSources: ()=>
    arr=@model.getContainerSources()
    i=0
    @sourceEndpoints=_.map arr, (block)=>
      e=jsPlumb.addEndpoint @el,
        hoverPaintStyle:{ fillStyle:"#89C27F" }
        anchor:[1,(++i)/(arr.length+1),1,0]
        isSource: true
      e.model=block
      e.blockView=this
      @bindSource(e)
      # e.bind 'click', (e1)=>
      #   floatingToolbarView.show(e1)
      $(e.canvas).append "<div class=\"sourceTitle\">#{block.endpointCaption()}</div>"
      sourceEndpoints.push e #window
      e

#то же
  addTargets: ()=>
    arr=@model.getContainerTargets()
    i=0
    @targetEndpoints=_.map arr, (block)=>
      e=jsPlumb.addEndpoint @el,
        hoverPaintStyle:{ fillStyle:"#89C27F" }
        anchor:[0,(++i)/(arr.length+1),-1,0]
        isTarget: true
      e.model=block
      e.blockView=this
      @bindTarget(e)
      $(e.canvas).append "<div class=\"targetTitle\">#{block.endpointCaption()}</div>"
      targetEndpoints.push e #window
      e



  render: =>
    $(@el).data("view",this) #круто!
    $(@el).html @template(@model)
    $(@el).addClass(@model.modelName)
    $(@el).attr("title",I18n.t('admin.'+@model.modelName+'.hint'))
    $(@el).css(left:"#{@model.get("x")}px",top:"#{@model.get("y")}px")
    if manage
      jsPlumb.draggable $(@el)
      $(@el).draggable("option","containment","parent")
      $(@el).draggable("option","delay",200)
      $(@el).draggable("option","distance",gridStep)
      $(@el).draggable("option","grid",[gridStep,gridStep])
    @rivestView=rivets.bind $(@el), {model: @model}
    this
