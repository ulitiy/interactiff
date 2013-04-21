Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.HelpView extends Backbone.View

  template: JST["backbone/templates/admin/help"]

  events:
    click:"showMenu"

  tagName: "div"
  className: "help tool"

  showMenu: =>
    helpMenuView.show()
    o=$(@el).offset()
    $(helpMenuView.el).offset
      left: o.left+$(@el).width(),
      top: o.top

  render: =>
    $(@el).html @template()
    this
