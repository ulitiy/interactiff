class Joygen.Routers.AdminRouter extends Backbone.Router
  initialize: (options) ->

  routes:
    ":id/:edit_id" : "index"

  initialize: ->
    window.masterCollection=new Joygen.Collections.BlocksCollection()
    window.relationsCollection=new Joygen.Collections.RelationsCollection()
    window.htmlModalView=new Joygen.Views.Admin.HtmlModalView()
    window.masterView=new Joygen.Views.Admin.MasterView
    window.pathView=new Joygen.Views.Admin.PathView
      el:$("#path")
    window.fieldView=new Joygen.Views.Admin.FieldView
      el:$("#field")
    window.toolbarView=new Joygen.Views.Admin.ToolbarView
      el:$("#toolbar")
    window.propertiesView=new Joygen.Views.Admin.PropertiesView
      el: $("#properties-container")
    window.floatingToolbarView=new Joygen.Views.Admin.FloatingToolbarView
      el: $("#floating-toolbar")
    window.levelUpView=new Joygen.Views.Admin.LevelUpView
      el: $("#lvl-up")
    window.reloadView=new Joygen.Views.Admin.ReloadView
      el: $("#reload")
    window.helpMenuView=new Joygen.Views.Admin.HelpMenuView
      el: $("#helpMenu")
    helpMenuView.render()

  index: (pid,eid) ->
    window.loading=true
    window.editId=(if eid=="0" then pid else eid)
    window.parentId=pid
    masterView.loadProperties()
    if @oldId!=parentId
      pathView.id=parentId
      fieldView.id=parentId
      if masterView.needLoad(parentId)
        masterView.loadCollection(parentId)
        masterView.setLoadOverlay()
      else
        masterView.renderViews()
      @oldId=parentId