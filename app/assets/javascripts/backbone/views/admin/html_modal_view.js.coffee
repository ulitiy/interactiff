Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.HtmlModalView extends Backbone.View

  render: =>
      @el=$('<div class="html-modal"></div>').appendTo("body").html("<textarea id=\"editor\"></textarea>")
      @el=@el.dialog
        modal: true,
        buttons:
          Ok: =>
            @hide()
        autoOpen: false
        width: 800
      @textarea=$("#editor",@el).wymeditor()
      @editor=jQuery.wymeditors(0)
      @el=@el[0]

  show: (event)=>
    forInput=$(event.currentTarget).data("for")
    @bindInput=$ "#properties ##{forInput}"
    @editor.html(@bindInput.val())
    @$el.dialog "open"
    @shown=true

  hide: =>
    @$el.dialog "close"
    @bindInput.val(@editor.html())
    @bindInput.trigger("change")
    @bindInput.focus()
    @shown=false
