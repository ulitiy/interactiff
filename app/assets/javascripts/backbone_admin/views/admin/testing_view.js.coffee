Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.TestingView extends Backbone.View

  events:
    "click" : "click"

  click: ->
    if confirm(I18n.t("admin.links.reset"))
      $.ajax
        type: "POST"
        url: "/scripts/#{parentGame.id}/reset"
        async: false
        success: =>
          window.open(@$el.attr("href"), "_blank").focus()
      return false
    else
      return true
