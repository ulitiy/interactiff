Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.HelpMenuView extends Backbone.View

  template: JST["backbone_admin/templates/admin/help_menu"]

  events:
    "click .menuEl": "click"

  click: (e)=>
    guide=$(e.target).data("guide")
    @hide()
    guiders.hideAll()
    if guide?
      guides.overview()
      guides.basic()
      guiders.show(guides["#{guide}Id"])
      false

  show: =>
    @$el.show()
  hide: =>
    @$el.hide()

  render: =>
    @$el.html @template()
    $('body').mousedown (e)=>
      if !$(e.target).hasClass('menuEl')
        @$el.hide()
    @$el.menu()
    this
