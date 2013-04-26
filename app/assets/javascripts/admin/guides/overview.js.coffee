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
  guiders.guiderFrom ["overview", "field",   [pb, nb],  "o-6", "o-7", null,null,true,"#field"]
  guiders.guiderFrom ["overview", "block",   [pb, nb], "o-7", "o-8", "#field .block.game_started, #field .block.task_given",6,true,"#field"]
  guiders.guiderFrom ["overview", "properties",   [cb, ngb], "o-8", "b-1", "#properties-container",10,true]

guides["basic"]= ->
  waitForConnection=->
    jsPlumb.bind "jsPlumbConnection", ->
      return if jsPlumb.silent || !connectionCallback
      window.connectionCallback=false
      setTimeout guiders.next
    window.connectionCallback=true
  waitNavigateToParent=(ptype)->
    window.guiderCallback=(p,c)->
      p=masterCollection.get(p).modelName
      if p==ptype
        router.off "route:index", guiderCallback
        guiders.next()
    router.on "route:index", guiderCallback
  waitNavigateToChild=(ctype)->
    window.guiderCallback=(p,c)->
      c=masterCollection.get(c).modelName if ctype!="0"
      if c==ctype
        router.off "route:index", guiderCallback
        guiders.next()
    router.on "route:index", guiderCallback

  guides.basicId="b-1"
  guiders.guiderFrom ["basic", "welcome", [nb], "b-1", "b-2", null, null, true, null, ->
    game=new Joygen.Models.Game()
    game.save "name", I18n.t("admin.help.options.basic"),
      success: ->
        router.navigate "#{game.id}/0",
          trigger:true
  ]
  guiders.guiderFrom ["basic", "create_task", null, "b-2", "b-3", "#toolbar .tool.task", 2, true, "#toolbar", ->
    $("#toolbar .tool.task").one "click", guiders.next
  ]
  guiders.guiderFrom ["basic", "start_task", null, "b-3", "b-4", ".block.game_started", 6, true, "#field", waitForConnection]
  guiders.guiderFrom ["basic", "finish_task", null, "b-4", "b-5", ".block.task", 12, true, "#field", waitForConnection]
  guiders.guiderFrom ["basic", "select_task", null, "b-5", "b-6", ".block.task:first", 6, true, "#field", ->
    if $(".block.task:first").hasClass("ui-selected")
      setTimeout guiders.next
    else
      waitNavigateToChild "task"
  ]
  guiders.guiderFrom ["basic", "task_name", null, "b-6", "b-7", "#properties-container", 10, true, null, ->
    $("#save-properties input").one "click", guiders.next
  ]
  guiders.guiderFrom ["basic", "enter_task", null, "b-7", "b-8", ".block.task:first", 6, true, "#field", ->
    waitNavigateToParent "task"
  ]
  guiders.guiderFrom ["basic", "toolbar", [nb], "b-8", "b-9", "#toolbar", 2, true]
  guiders.guiderFrom ["basic", "select_tg", null, "b-9", "b-10", ".block.task_given", 6, true, "#field", ->
    waitNavigateToChild "task_given"
  ]
  guiders.guiderFrom ["basic", "tg_body", null, "b-10", "b-11", "#properties-container", 10, true, null, ->
    $("#save-properties input").one "click", guiders.next
  ]

  guiders.guiderFrom ["basic", "select_field", null, "b-11", "b-12", null, null, true, "#field", ->
    waitNavigateToChild "0"
  ]
  guiders.guiderFrom ["basic", "set_choice", null, "b-12", "b-13", "#properties-container", 10, true, null, ->
    $("#save-properties input").one "click", guiders.next
  ]
  guiders.guiderFrom ["basic", "create_answers", null, "b-13", "b-14", "#toolbar .tool.answer", 2, true, "#toolbar", ->
    window.answerCount=0
    window.guiderCallback=->
      window.answerCount+=1
      if answerCount==3
        $("#toolbar .tool.answer").off "click", guiderCallback
        guiders.next()
    $("#toolbar .tool.answer").on "click", guiderCallback
  ]
  guiders.guiderFrom ["basic", "right_answer", null, "b-14", "b-15", ".block.task_passed", 12, false, null, waitForConnection]
  guiders.guiderFrom ["basic", "get_back", null, "b-15", "b-16", "#lvl-up", 7, true, "#header", ->
    waitNavigateToParent "game"
  ]
  guiders.guiderFrom ["basic", "delete_block", null, "b-16", "b-17", ".block.and_block:first", 1, true, "#field", ->
    $("#toolbar .tool.and_block").trigger "click"
    $(".block.and_block:first").data("view").model.on "destroy", -> guiders.next()
  ]
  guiders.guiderFrom ["basic", "delete_relation", [nb], "b-17", "b-18", null, null, true]
  guiders.guiderFrom ["basic", "select_gs", null, "b-18", "b-19", ".block.game_started", 6, true, "#field", ->
    waitNavigateToChild "game_started"
  ]
  guiders.guiderFrom ["basic", "launch_quest", null, "b-19", "b-20", "#properties-container", 10, true, null, ->
    $("#save-properties input").one "click", guiders.next
  ]
  guiders.guiderFrom ["basic", "try_quest", [cb,tb,ngb], "b-20", "n-1", null, null, true]


guides["nl_quests"]= ->
guides["variables"]= ->
guides["requests"]= ->
guides["hot_keys"]= ->
