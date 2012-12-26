Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.PathView extends Backbone.View

  addPadder: =>
    padder=$('<span class="padder">›</span>')
    $(@el).append(padder)

  addAll: =>
    rbv=new Joygen.Views.Admin.PathElementView(model:rootBlock)
    $(@el).append(rbv.render().el)
    _.each(pathCollection,@addOne)

  addOne: (block)=>
    @addPadder()
    view=new Joygen.Views.Admin.PathElementView(model:block)
    $(@el).append(view.render().el)

  render: =>
    window.parentGame=null
    window.parentTask=null
    $(@el).html("")
    window.pathCollection=masterCollection.path(@id)
    @addAll()
