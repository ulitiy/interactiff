Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.HtmlModalView extends Backbone.View

  render: =>
      @el=$('<div class="html-modal"></div>').appendTo("body").html("<textarea id=\"editor\"></textarea>")
      @dialog=@el.dialog
        modal: true,
        buttons:
          Ok: =>
            @hide()
        autoOpen: false
        width: 800
      @textarea=$("#editor",@el).wysihtml5
        "font-styles": false
        "html": true
      @editor=@textarea.data("wysihtml5").editor
      @el=@el[0]

  show: (event)=>
    forInput=$(event.currentTarget).data("for")
    @bindInput=$ "#properties ##{forInput}"
    @editor.setValue @bindInput.val()
    @dialog.dialog "open"
    @shown=true

  hide: =>
    @dialog.dialog "close"
    @bindInput.val(@textarea.val())
    @bindInput.trigger("change")
    @bindInput.focus()
    @shown=false
