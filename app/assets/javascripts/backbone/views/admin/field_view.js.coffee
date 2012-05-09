Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.FieldView extends Backbone.View

  initialize: ->
    masterCollection.on 'reset', @render
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
    router.loadCollection(@id)

  selectablestop: =>
    $("#keyInput").focus()
    window.selected=$('.ui-selected') #нужно для массового дрэга
    if selected.length==1
      selected.trigger("selectedone")
    else
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

  addStretcher: =>
    $(@el).append('<div id="stretcher"></div>')

  addKeyInput: =>
    $(@el).append('<input type="text" id="keyInput"/>')
    $("#keyInput",@el).keydown (e)=>
      switch e.which
        when $.ui.keyCode.BACKSPACE, $.ui.keyCode.DELETE
          @deleteKey()
        when $.ui.keyCode.UP
          Joygen.Views.Admin.BlockView.prototype.move(0,-gridStep)
        when $.ui.keyCode.DOWN
          Joygen.Views.Admin.BlockView.prototype.move(0,gridStep)
        when $.ui.keyCode.LEFT
          Joygen.Views.Admin.BlockView.prototype.move(-gridStep,0)
        when $.ui.keyCode.RIGHT
          Joygen.Views.Admin.BlockView.prototype.move(gridStep,0)
        else return true
      false


  refreshTemplate: JST["backbone/templates/admin/refresh"]

  render: =>
    @options.blocks=masterCollection.children(@id)
    window.parentBlock=masterCollection.get(@id) || rootBlock
    $(@el).html('')
    #window.blockViews=[]
    window.targetEndpoints=[]
    window.sourceEndpoints=[]
    @addBlocks()
    @addRelations()
    @addStretcher()
    @addKeyInput()
    $(@el).append(@refreshTemplate)
