Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.FloatingToolbarView extends Backbone.View

  addAll: ()=>
    tools=parentBlock.outTools()
    i=1
    _.each tools,(tool)=>
      @addOne(tool,i++)

  addOne: (tool,num)=>
    view=new Joygen.Views.Admin.FloatingToolView(tool:tool,num:num)
    @$el.append(view.render().el)

  render: =>
    @el=$("#floating-toolbar")
    @$el.html('')
    @addAll()

  choose: =>
    ;

  show: (endpoint)=>
    eb=$(if endpoint? endpoint.blockView.el else editBlockView.el)
    eb.data('view')
    offset=eb.offset()
    @$el.show()
    @$el.offset(top:offset.top+eb.height()+22,left:offset.left+eb.width()+38)
    @shown=true

  hide: =>
    @$el.hide()
    @shown=false
