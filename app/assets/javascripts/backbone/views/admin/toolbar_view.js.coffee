Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.ToolbarView extends Backbone.View

  addAll: ()=>
    tools=parentBlock.tools
    _.each(tools,@addOne)

  addOne: (tool)=>
    view=new Joygen.Views.Admin.ToolView(tool:tool)
    @$el.append(view.render().el)

  addHelp: =>
    view=new Joygen.Views.Admin.HelpView()
    @$el.append(view.render().el)

  render: =>
    @$el.html('')
    @addAll()
    @addHelp()
