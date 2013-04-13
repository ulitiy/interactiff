Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.ToolView extends Backbone.View

  template: JST["backbone/templates/admin/help"]

  tagName: "div"
  className: "help"

  render: =>
    $(@el).html @template()
    this
