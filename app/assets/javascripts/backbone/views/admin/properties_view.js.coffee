Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.PropertiesView extends Backbone.View
  initialize: ->
    masterCollection.on 'reset', @reset
    $(window).unload @save #TODO???

  events:
    "click #save-properties input" : "save"

  reset: =>
    @model=null #предварительно чистим модель, чтобы при рефреше не было сохранения//не трогать
    @render()

  template: JST["backbone/templates/admin/properties/common"]

  save: =>
    $("*:focus").not("#keyInput").blur()
    @model.save() if @model? && @model.modelChanged

  draw: (newmodel)=>
    @model=newmodel
    $(@el).html(@template(@model))
    Backbone.ModelBinding.bind(this);

  clear: =>
    $(@el).html("")
    @model=null

  render: =>
    Backbone.ModelBinding.unbind this
    newmodel=masterCollection.get(@id)
    @save() if @model!=newmodel || !newmodel?
    if newmodel? && newmodel!=rootBlock
      @draw(newmodel)
    else
      @clear()
