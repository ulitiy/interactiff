Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.PathView extends Backbone.View

  events:
    "mouseenter #scroller-left" : "scrollLeft"
    "mouseenter #scroller-right" : "scrollRight"
    "mouseleave #scroller-left" : "stopScroll"
    "mouseleave #scroller-right" : "stopScroll"

  addPadder: =>
    padder=$("<div> > </div>")
    $("#path",@el).append(padder)

  addAll: =>
    rbv=new Joygen.Views.Admin.PathElementView(model:rootBlock)
    $("#path",@el).append(rbv.render().el)
    _.each(@options.pathCollection,@addOne)

  addOne: (block)=>
    @addPadder()
    view=new Joygen.Views.Admin.PathElementView(model:block)
    $("#path",@el).append(view.render().el)

  addLvlUp: =>
    uv=new Joygen.Views.Admin.PathElementView(model:@options.pathCollection[@options.pathCollection.length-2]||rootBlock)
    uv.template=JST["backbone/templates/admin/lvl_up"]
    el=uv.render().el
    $(el).attr("id","lvl-up")
    $(@el).append el

  scrollLeft: =>
    @interval=setInterval ->
      el=$("#path",@el)
      el.scrollLeft(el.scrollLeft()-20)
    ,50

  scrollRight: =>
    @interval=setInterval ->
      el=$("#path",@el)
      el.scrollLeft(el.scrollLeft()+20)
    ,50

  stopScroll: =>
    clearInterval @interval

  addScrollers: =>
    $(@el).append '<div id="scroller-right"></div><div id="scroller-left"></div>' if $("#path",@el)[0].scrollWidth-$("#path",@el).width()>10

  render: =>
    window.parentGame=null
    window.parentTask=null
    @options.pathCollection=masterCollection.path(@id)
    $(@el).html('<div id="path"></div>')
    @addAll()
    @addLvlUp() unless @options.pathCollection.length==0
    @addScrollers()
