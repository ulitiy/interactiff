window.guides||={}
$ ->
  window.pb={name: I18n.t("admin.guides.buttons.prev"),onclick: guiders.prev}
  window.nb={name: I18n.t("admin.guides.buttons.next"),onclick: guiders.next}
  window.tb={name: I18n.t("admin.guides.buttons.try"),onclick: ->
    window.open("/#{locale}/play/#{parentGame.id}")
  }
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
    highlight: arr[8] || arr[5]
    onShow: arr[9]
  }
guiders.guiderFrom= (arr)->
  guiders.createGuider guiders.optionsFrom(arr)

guides["overview"]= ->
  guides.overviewId="o-1"
  guiders.guiderFrom ["overview", "welcome", [nb],      "o-1", "o-2", null,null,true]
  guiders.guiderFrom ["overview", "header",  [pb, nb],  "o-2", "o-3", "#header",6,true]
  guiders.guiderFrom ["overview", "reload",  [pb, nb],  "o-3", "o-4", "#reload",5,true,"#header"]
  guiders.guiderFrom ["overview", "toolbar", [pb, nb],  "o-4", "o-5", "#toolbar",2,true]
  guiders.guiderFrom ["overview", "tool",    [pb, nb],  "o-5", "o-6", "#toolbar",2,true]
  guiders.guiderFrom ["overview", "field",   [pb, nb],  "o-6", "o-7", null,null,true,"#field-container"]
  guiders.guiderFrom ["overview", "block",   [pb, nb], "o-7", "o-8", "#field .block.game_started, #field .block.task_given",6,true,"#field-container"]
  guiders.guiderFrom ["overview", "properties",   [cb, ngb], "o-8", "b-1", "#properties-container",10,true]
