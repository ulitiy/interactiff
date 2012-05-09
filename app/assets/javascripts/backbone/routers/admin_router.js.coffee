class Joygen.Routers.AdminRouter extends Backbone.Router
  initialize: (options) ->

  routes:
    "admin/:id/:edit_id" : "index"

  initialize: ->
    window.masterCollection=new Joygen.Collections.BlocksCollection()
    window.relationsCollection=new Joygen.Collections.RelationsCollection()
    window.pathView=new Joygen.Views.Admin.PathView #путь раньше всех, чтобы родители загрузились раньше
      el:$("#path-container")
    window.fieldView=new Joygen.Views.Admin.FieldView
      el:$("#field")
    window.toolbarView=new Joygen.Views.Admin.ToolbarView
      el:$("#toolbar")
    window.propertiesView=new Joygen.Views.Admin.PropertiesView
      el: $("#properties-container")

  index: (id,eid) ->
    id=parseInt(id)
    eid=parseInt(eid)
    window.editId=eid
    window.parentId=id
    window.loading=true
    @loadProperties(eid)
    if @oldId!=id
      pathView.id=id
      fieldView.id=id
      if @needLoad(id)
        @loadCollection(id)
        @setLoadOverlay()
      else
        # masterCollection.fetch local:true
        @renderViews()
      @oldId=id

  needLoad: (id)->
    # return false
    el=masterCollection.get(id)
    !el? || el.get("type")=="Domain" || el.get("type")=="Game" #&& el.children().length==0 #TODO #because I/O

  loadCollection: (id)->
    $.ajax
      url: "/blocks/#{id}"
      success: (data)->
        relationsCollection.reset data.relations
        # masterCollection.storage.sync.reset masterCollection.parse(data.blocks)
        masterCollection.reset masterCollection.parse(data.blocks)
        window.loading=false
        loadingOverlay.hide()

  renderViews: ->
    pathView.render()
    fieldView.render()
    toolbarView.render()
    propertiesView.render()

  loadProperties: (id) ->
    propertiesView.id=id
    propertiesView.render() if masterCollection.length || parentId? && id==parentId
    #рендер при тыке на блок (коллекция уже загружена, иначе - после загрузки)
    #либо когда удаляем все блоки на поле, надо выбрать предка

  load_timeout: 300

  setLoadOverlay: ->
    setTimeout ->
        loadingOverlay.show() if loading
      ,@load_timeout
