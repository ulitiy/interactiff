Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.SourceView extends Backbone.View

  template: JST["backbone_admin/templates/admin/source"]

    # "click .sourceTitle":"showForm"

  # events:
  #   "click":"a"

  # a: ->
  #   alert("")

  #Как-нибудь сделать @el и нормальные events???
  #Закэшировать внутренние элементы!!!

  showForm: ->
    selectedSourceView?.hideForm()
    window.selectedSourceView=this
    @$el.find(".sourceTitle").hide()
    @$el.find('.editForm').show()
    @$el.addClass "selected"
    @$el.find(".editForm input.answer").focus().select()
  hideForm: ->
    @$el.find("*:focus").blur()
    window.selectedSourceView=undefined
    @$el.find(".sourceTitle").show()
    @$el.find('.editForm').hide()
    @$el.removeClass "selected"
    @model.save()


  # endpoint===el

  render: ->
    @endpoint=jsPlumb.addEndpoint @options.blockView.el,
      hoverPaintStyle:{ fillStyle:"#89C27F" }
      anchor: @options.anchor
      isSource: true
    @endpoint.view=this
    @el=@endpoint.canvas
    @$el=$(@endpoint.canvas)
    if @options.blockView.model.modelName=="task"
      @$el.append @template(@model)
    if parentTask?
      @bindCS()
    else
      if @model.modelName=="answer"
        @bindForm()
    @bindDragConnection()
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

  bindCS: ->
    @$el.attr("data-class-containersource","model.container_source")
    @endpoint.bind 'dblclick', =>
      # return unless @model.get("task_id")?
      $(dragConnectionFrom.endpoint.canvas).removeClass "dcf" if dragConnectionFrom?
      window.dragConnectionFrom=null
      @model.set("container_source", !@model.get("container_source"))
      @model.save()

  bindForm: ->
    @$el.find(".sourceTitle").click (e)=>
      @showForm()
      e.stopPropagation()
    @$el.find(".editForm").click (e)->
      e.stopPropagation()
    @$el.find(".editForm .submit").click (e)=>
      @hideForm()
    @$el.find(".editForm .delete").click (e)=>
      return unless confirm(I18n.t("admin.links.sure"))
      jsPlumb.deleteEndpoint(@endpoint)
      @model.destroy()
      window.selectedSourceView=undefined
      @options.blockView.sourceViews=_.without(@options.blockView.sourceViews, this)
      @options.blockView.redraw()

  bindDragConnection: ->
    @endpoint.bind 'click', =>
      $(dragConnectionFrom.endpoint.canvas).removeClass "dcf" if dragConnectionFrom?
      window.dragConnectionFrom=this
      @$el.addClass "dcf"

# @endpoint.bind 'click', (e1)=>
#   floatingToolbarView.show(e1)
