Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.LevelUpView extends Backbone.View

  events:
    "click": "click"

  click: ->
    if @model.id==0
      return true
    router.navigate @path,
      trigger:true
    false

  setModel: ->
    @model=pathCollection[pathCollection.length-2]||rootBlock
    @path=@model.adminPath()
    $(@el).attr("href",if @model.id==0 then "/" else "/admin/"+@path)