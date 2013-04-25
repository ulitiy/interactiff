Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.FieldView extends Backbone.View

  initialize: ->
    masterCollection.on 'add', @collectionAdd
    return unless manage
    $(@el).selectable
      filter:'.block'
      cancel:'svg'
      # distance: 1

  selectableEnable: ->
    $(@el).selectable "enable" if manage

  selectableDisable: ->
    $(@el).selectable "disable" if manage

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
    $(dragConnectionFrom.canvas).removeClass "dcf" if dragConnectionFrom?
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
    view=new Joygen.Views.Admin.BlockView(model:block)
    #blockViews.push view #добавляем вьюху в массив для последующего связывания
    $(@el).append(view.render().el)
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
    _.each sourceEndpoints, @addEndpointsRelations #берем все исходящие ep

  addEndpointsRelations: (sep)=>
    _.each sep.model.outRelations(), (relation)-> #берем все исходящие стрелки из ep
      tep=_.find targetEndpoints, (e)-> #ищем среди текущих tep
        e.model.id==relation.get("to_id") #ту, в которую приходит стрелка
      if tep
        relView=new Joygen.Views.Admin.RelationView
          model:relation
          sourceEndpoint:sep
          targetEndpoint:tep
        relView.render()

  addElements: =>
    $(@el).append('<div id="stretcher"></div>')
    $(@el).append('<div id="floating-toolbar"></div>')

  render: =>
    @options.blocks=masterCollection.children(@id)
    $(@el).html('')
    #window.blockViews=[]
    window.targetEndpoints=[]
    window.sourceEndpoints=[]
    @addBlocks()
    @addRelations()
    @addElements()
