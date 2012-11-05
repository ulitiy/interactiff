Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.FieldView extends Backbone.View

  initialize: ->
    masterCollection.on 'add', @collectionAdd
    $(@el).selectable
      filter:'.block'
      cancel:'#refresh,svg'

  events:
    "selectablestop" : "selectablestop"
    "click #refresh" : "refresh"

  deleteKey: =>
    sel=$(".ui-selected") #TODO
    sel=_.filter sel, (domEl)->
      $(domEl).data("view").model.deletable
    sel=$(sel)
    return false unless sel.length
    if  confirm(I18n.t("links.sure"))
      sel.trigger "destroy"
      router.navigate (parentBlock||rootBlock).adminPath(),
        trigger:true
      @setSelect()
    return false

  refresh: =>
    masterView.loadCollection(@id)

  selectablestop: =>
    floatingToolbarView.hide()
    window.selected=$('.ui-selected') #нужно для массового дрэга
    if selected.length==1
      selected.trigger("selectedone")
    else
      window.editBlockView=null
      router.navigate (parentBlock||rootBlock).adminPath(),
        trigger:true


  collectionAdd: (block)=>
    @addBlock(block) if @id==block.get("parent_id") || !block.get("parent_id")?

  addBlocks: =>
    _.each(@options.blocks,@addBlock)

  addBlock: (block)=>
    view=new Joygen.Views.Admin.BlockView(model:block)
    #blockViews.push view #добавляем вьюху в массив для последующего связывания
    $(@el).append(view.render().el)
    @setSelect($(view.el)) if editId==block.id
    view.makeEndpoints()

  setSelect: (arr)->
    $(".ui-selected").removeClass("ui-selected")
    arr.addClass("ui-selected") if arr?

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

  refreshTemplate: JST["backbone/templates/admin/refresh"]

  render: =>
    @options.blocks=masterCollection.children(@id)
    $(@el).html('')
    #window.blockViews=[]
    window.targetEndpoints=[]
    window.sourceEndpoints=[]
    @addBlocks()
    @addRelations()
    @addElements()
    $(@el).append(@refreshTemplate)
