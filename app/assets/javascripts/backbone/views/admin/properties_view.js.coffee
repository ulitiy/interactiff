Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.PropertiesView extends Backbone.View
  initialize: ->
    $(window).unload @save #TODO???

  events:
    "click #save-properties input" : "save"
    "click .html" : "htmlModal"

  reset: =>
    @model=null #предварительно чистим модель, чтобы при рефреше не было сохранения//не трогать
    @render()

  template: JST["backbone/templates/admin/properties/common"]

  htmlModal: (event)=>
    htmlModalView.show(event)

  save: =>
    @model.save({},{ success: (model)-> model.dirty=false }) if @model? && @model.dirty

  draw: (newmodel)=>
    @model=newmodel
    @$el.html(@template(@model))
    @rivetsView=rivets.bind @$el, model: @model
    @setTimePicker()

  setTimePicker: =>
    $(".timer",@$el).datetimepicker
      showSecond: true
      timeOnly: true
      hourMax: 120
      timeFormat: "H:mm:ss"
    $(".datetime",@$el).datetimepicker
      showSecond: true
      timeFormat: "HH:mm:ss"
      dateFormat: "yy-mm-dd"

  setFocus: =>
    $("#"+editBlock.mainField).focus().select()

  clear: =>
    @$el.html("")
    @model=null

  render: =>
    @rivetsView?.unbind()
    window.editBlock=masterCollection.get(editId)
    @save() if @model!=editBlock || !editBlock?
    if editBlock? && editBlock!=rootBlock
      @draw(editBlock)
    else
      @clear()
    $(":input", @$el).attr("disabled", true) unless manage
