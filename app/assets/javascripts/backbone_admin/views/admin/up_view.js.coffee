Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.UpView extends Backbone.View

  events:
    "click" : "click"

  tagName: "div"
  className: "back"

  click: ->
    router.navigate parentGame.adminPath(),
      trigger:true
  render: ->
    @$el.html('<input type="button" class="btn" value="'+I18n.t("admin.path.level_up")+'" />')
    @$el.attr("id","lvl-up")
    this
