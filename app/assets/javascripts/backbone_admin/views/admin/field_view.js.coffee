Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.FieldView extends Backbone.View

  initialize: ->
    masterCollection.on 'add', @collectionAdd
    return unless manage
    @$el.mousedown (event) -> #для того чтобы скроллбары работали
      $t = $(event.target)
      if (event.pageX > $t.width() + $t.offset().left || event.pageY > $t.height() + $t.offset().top)
          event.stopImmediatePropagation()
          return false
    @$el.selectable
      filter:'.block'
      cancel:'svg'
      # appendTo: '#field' #http://bugs.jqueryui.com/ticket/4377
      # distance: 1

  selectableEnable: ->
    @$el.selectable "enable" if manage

  selectableDisable: ->
    @$el.selectable "disable" if manage

  events:
    "selectablestop" : "selectablestop"
    "click" : "click"

  click: (e)=>
    return if e.target!=@el || manage
    @blurSelect()


  refresh: =>
    masterView.loadCollection(@id)

  deleteKey: =>
    return false unless manage
    sel=$(".ui-selected") #TODO
    sel=_.filter sel, (domEl)->
      $(domEl).data("view").model.deletable
    sel=$(sel)
    return false unless sel.length
    if  confirm(I18n.t("admin.links.sure"))
      sel.trigger "destroy"
      @blurSelect()
    return false


  selectablestop: =>
    $(dragConnectionFrom.endpoint.canvas).removeClass "dcf" if dragConnectionFrom?
    window.dragConnectionFrom=null
    $("*:focus").blur()
    # floatingToolbarView.hide()
    window.selected=$('.ui-selected') #нужно для массового дрэга
    if selected.length==1
      selected.trigger("selectedone")
    else
      # window.editBlockView=null
      router.navigate (parentBlock||rootBlock).adminPath(),
        trigger:true
        replace:true


  collectionAdd: (block)=>
    if @id==block.get("parent_id") || !block.get("parent_id")?
      @addBlock(block)
      block.on "change:id", ->
        setTimeout =>
          router.navigate "#{parentId}/#{@id}",
            trigger:true
            replace:true
          propertiesView.setFocus()
          fieldView.setSelect $(@view.el)

  addBlocks: =>
    _.each(@options.blocks,@addBlock)

  addBlock: (block)=>
    # return if block.get("type")=="TaskPassed" #!!!
    view=new Joygen.Views.Admin.BlockView(model:block)
    #blockViews.push view #добавляем вьюху в массив для последующего связывания
    @$el.append(view.render().el)
    block.view=view
    @setSelect($(view.el)) if editId==block.id
    view.makeEndpoints()

  setSelect: (arr)->
    $(".ui-selected").removeClass("ui-selected")
    arr.addClass("ui-selected") if arr?

  blurSelect: ->
    router.navigate (parentBlock||rootBlock).adminPath(),
      trigger:true
      replace:true
    $(".ui-selected").removeClass("ui-selected")

  addRelations: =>
    _.each sourceViews, (view)-> view.addRelations()

  addElements: ->
    @$el.append('<div id="stretcher"></div>')
    @$el.append('<div id="floating-toolbar"></div>')

  addTaskName: ->
    @taskNameView=new Joygen.Views.Admin.TaskNameView()
    @$el.parent().append @taskNameView.render().el

  removeTaskName: ->
    @taskNameView.remove() if @taskNameView?

  render: =>
    # jsPlumb.doWhileSuspended =>
      @options.blocks=masterCollection.children(@id)
      @$el.html('')
      #window.blockViews=[]
      window.targetViews=[]
      window.sourceViews=[]
      @removeTaskName()
      @addTaskName() if parentTask?
      @addBlocks()
      @addRelations()
      @addElements()
