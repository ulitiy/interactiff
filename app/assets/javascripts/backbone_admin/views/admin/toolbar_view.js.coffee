Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.ToolbarView extends Backbone.View

  addAll: ()=>
    tools=parentBlock.tools
    _.each(tools,@addOne)

  addOne: (tool)=>
    view=new Joygen.Views.Admin.ToolView(tool:tool)
    @$el.append(view.render().el)

  addHelp: =>
    window.helpView=new Joygen.Views.Admin.HelpView()
    @$el.append(helpView.render().el)

  addUp: =>
    window.upView=new Joygen.Views.Admin.UpView()
    @$el.append(upView.render().el)

  render: =>
    @$el.html('')
    @addUp() if parentTask?
    @addAll()
    @addHelp()
