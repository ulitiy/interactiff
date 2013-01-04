Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.MasterView extends Backbone.View
  initialize: ->
    masterCollection.on 'reset', @reset
    htmlModalView.render()

  reset: =>
    @unsetLoadOverlay()
    @renderViews()

  renderViews: ->
    window.parentBlock=masterCollection.get(parentId) || rootBlock
    window.editBlock=masterCollection.get(editId)
    fieldView.render()
    propertiesView.render()
    pathView.render()
    toolbarView.render()
    floatingToolbarView.render()
    fieldView.selectablestop()
    levelUpView.setModel()


  loadProperties: ->
    propertiesView.render() if masterCollection.length || parentId? && editId==parentId
    #рендер при тыке на блок (коллекция уже загружена, иначе - после загрузки)
    #либо когда удаляем все блоки на поле, надо выбрать предка

  needLoad: (id)->
    # return false
    el=masterCollection.get(id)
    !el? || el.get("type")=="Domain" || el.get("type")=="Game" && el.children().length==0

  loadCollection: (id)->
    $.ajax
      url: "/blocks/#{id}"
      success: (data)->
        relationsCollection.reset data.relations
        masterCollection.reset masterCollection.parse(data.blocks)

  load_timeout: 300

  setLoadOverlay: ->
    setTimeout ->
        loadingOverlay.show() if loading
      ,@load_timeout

  unsetLoadOverlay: ->
    window.loading=false
    loadingOverlay.hide()
