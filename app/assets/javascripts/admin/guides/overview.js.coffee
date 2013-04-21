window.guides||={}
$ ->
  window.pb={name: I18n.t("admin.guides.buttons.prev"),onclick: guiders.prev}
  window.nb={name: I18n.t("admin.guides.buttons.next"),onclick: guiders.next}
  window.ngb={name: I18n.t("admin.guides.buttons.next_guide"),onclick: guiders.next}
  window.cb={name: I18n.t("admin.guides.buttons.close"),onclick: guiders.hideAll}
guiders.optionsFrom= (arr)->
  {
    title: I18n.t("admin.guides.#{arr[0]}.#{arr[1]}.title")
    description: I18n.t("admin.guides.#{arr[0]}.#{arr[1]}.description")
    buttons: arr[2]
    id: arr[3]
    next: arr[4]
    attachTo: arr[5]
    position: arr[6]
    overlay: arr[7]
  }
guiders.guiderFrom= (arr)->
  guiders.createGuider guiders.optionsFrom(arr)

guides["overview"]= ->
  guiders.guiderFrom(["overview", "welcome", [nb],      "o-1", "o-2", null,null,true]).show()
  guiders.guiderFrom(["overview", "header",  [pb, nb],  "o-2", "o-3", "#header",6])
  guiders.guiderFrom(["overview", "reload",  [pb, nb],  "o-3", "o-4", "#reload",5])
  guiders.guiderFrom(["overview", "toolbar", [pb, nb],  "o-4", "o-5", "#toolbar",3])
  guiders.guiderFrom(["overview", "tool",    [pb, nb],  "o-5", "o-6", "#toolbar .tool:first",2])
  guiders.guiderFrom(["overview", "field",   [pb, nb],  "o-6", "o-7", null,null])
  guiders.guiderFrom(["overview", "block",   [cb, ngb], "o-7", "b-1", "#field .block:first",4])
guides["basic"]= ->
guides["nl_quests"]= ->
guides["variables"]= ->
guides["requests"]= ->
guides["hot_keys"]= ->
