Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.BlockView extends Backbone.View

  template: JST["backbone_admin/templates/admin/block"]

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
      jsPlumb.repaint @$el

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
    return if @$el.hasClass("ui-selected")
    fieldView.setSelect(@$el)
    $("#field").trigger('selectablestop')
  dragstop: =>
    selected.trigger("dragstopchild")
  dragstopchild: =>
    @model.setPosition @$el.css_position()
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
      if newtop>5
        $(this).css top:newtop
      else
        $(this).css top:5
      if newleft>5
        $(this).css left:newleft
      else
        $(this).css left:5
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
    @rivetsView.unbind()
    jsPlumb.removeAllEndpoints @el

#простановка всех эндпоинтов блока, сначала родных, потом дочерних
  makeEndpoints: ()=>
    if @model.isTarget?()
      @targetView=new Joygen.Views.Admin.TargetView
        blockView: this
        model: @model
        anchor: "LeftMiddle"
      @targetView.render()

      targetViews.push @targetView
    if @model.isSource?()
      @sourceView=new Joygen.Views.Admin.SourceView
        blockView: this
        model: @model
        anchor: "RightMiddle"
      @sourceView.render()
      sourceViews.push @sourceView
    if @model.container?()
      @addSources()
      @addTargets()
      m=Math.max @sourceViews.length, @targetViews.length
      @$el.css("min-height",m*14)
      jsPlumb.repaint @$el

#простановка дочерних
  addSources: ()=>
    arr=@model.getContainerSources()
    i=0
    @sourceViews=_.map arr, (block)=>
      v=new Joygen.Views.Admin.SourceView
        blockView: this
        model: block
        anchor: [1,(++i)/(arr.length+1),1,0]
      v.render()
      sourceViews.push v
      v

#то же
  addTargets: ()=>
    arr=@model.getContainerTargets()
    i=0
    @targetViews=_.map arr, (block)=>
      v=new Joygen.Views.Admin.TargetView
        blockView: this
        model: block
        anchor: [0,(++i)/(arr.length+1),-1,0]
      v.render()
      targetViews.push v
      v

  render: =>
    @$el.data("view",this) #круто!
    @$el.html @template(@model)
    @$el.addClass(@model.modelName)
    @$el.attr("title",I18n.t('admin.'+@model.modelName+'.hint'))
    @$el.attr("data-class-exception","model.exception")
    @$el.attr("data-title","model.exception")
    @$el.css(left:"#{@model.get("x")}px",top:"#{@model.get("y")}px")
    if manage
      jsPlumb.draggable @$el
      @$el.draggable("option","containment","parent")
      @$el.draggable("option","delay",200)
      @$el.draggable("option","distance",gridStep)
      @$el.draggable("option","grid",[gridStep,gridStep])
    @rivetsView=rivets.bind @$el, {model: @model}
    this
