Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.MasterView extends Backbone.View
  initialize: ->
    masterCollection.on 'reset', @reset
    htmlModalView.render()

  reload: ->
    @loadCollection(parentBlock.id)
    @setLoadOverlay()


  reset: => #двойная стрелочка во вьюхах нужна если стоит хук на модель/коллекцию
    @renderViews()
    @unsetLoadOverlay()

  renderViews: ->
    @setParentModels()
    #исправляет косяк с полями внутри таска
    adminLayout.resizeAll()
    fieldView.render()
    propertiesView.render()
    toolbarView.render()
    # floatingToolbarView.render()
    fieldView.selectablestop()

  setParentModels: ->
    window.parentBlock=masterCollection.get(parentId) || rootBlock
    window.editBlock=masterCollection.get(editId)
    if parentBlock.task?
      $("body").addClass("in-task")
      window.parentTask=parentBlock
      window.parentGame=parentTask.parent()
    else
      if parentBlock.get("type")=="Game"
        $("body").removeClass("in-task")
        window.parentGame=parentBlock
        window.parentTask=null
    @gameNameRivetsView.unbind() if @gameNameRivetsView? #ПЕРЕНЕСТИ В ОТДЕЛЬНУЮ ВЬЮХУ
    @gameNameRivetsView=rivets.bind $("#game-name"), { model: parentGame }

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
      url: "/blocks/#{id}/master"
      success: (data)->
        relationsCollection.reset data.relations
        masterCollection.reset masterCollection.parse(data.blocks)

  setLoadOverlay: ->
    setTimeout ->
      loadingOverlay.show()
      reloadView.$el.addClass("thinking")
    , 0

  unsetLoadOverlay: ->
    setTimeout ->
      loadingOverlay.hide()
      reloadView.$el.removeClass("thinking")
    , 1
