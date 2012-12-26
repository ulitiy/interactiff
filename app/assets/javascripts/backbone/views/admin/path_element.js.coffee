Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.PathElementView extends Backbone.View

  template: JST["backbone/templates/admin/path_element"]
  tagName: "span"
  className: "path-element"

  events:
    "click":"click"

  click: =>
    router.navigate @model.adminPath(),
      trigger:true
    false

  render: =>
    $(@el).html(@template(@model))
    Backbone.ModelBinding.bind(this);
    this
