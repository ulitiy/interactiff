Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.ToolbarView extends Backbone.View

  initialize: ()->
    masterCollection.on('reset',@render)

  addAll: ()=>
    tools=parentBlock.tools
    _.each(tools,@addOne)

  addOne: (tool)=>
    view=new Joygen.Views.Admin.ToolView(tool:tool)
    $(@el).append(view.render().el)

  render: =>
    $(@el).html('')
    @addAll()
