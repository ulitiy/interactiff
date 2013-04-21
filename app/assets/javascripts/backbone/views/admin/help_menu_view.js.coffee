Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.HelpMenuView extends Backbone.View

  template: JST["backbone/templates/admin/help_menu"]

  events:
    "click .menuEl": "click"

  click: (e)=>
    guide=$(e.target).data("guide")
    @hide()
    if guide?
      guides[guide]()
      false

  show: =>
    $(@el).show()
  hide: =>
    $(@el).hide()

  render: =>
    $(@el).html @template()
    $('body').mousedown (e)=>
      if !$(e.target).hasClass('menuEl')
        $(@el).hide()
    $(@el).menu()
    this
