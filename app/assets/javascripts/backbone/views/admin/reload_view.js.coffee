Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.ReloadView extends Backbone.View

  events:
    "click" : "click"

  click: ->
    masterView.loadCollection(parentBlock.id)
    false
