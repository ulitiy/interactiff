Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.TaskNameView extends Backbone.View

  template: JST["backbone_admin/templates/admin/task_name"]

  events:
    click: "click"

  tagName: "div"
  className: "taskName"

  click: =>
    $(".ui-selected").removeClass("ui-selected")
    router.navigate parentTask.adminPath(),
      trigger:true
      replace:true
    propertiesView.setFocus()


  render: ->
    @$el.html @template()
    rivets.bind @$el, {model: parentTask}
    this
