class Joygen.Routers.AdminRouter extends Backbone.Router
  initialize: (options) ->

  routes:
    ":id/:edit_id" : "index"

  initialize: ->
    window.masterCollection=new Joygen.Collections.BlocksCollection()
    window.relationsCollection=new Joygen.Collections.RelationsCollection()
    window.htmlModalView=new Joygen.Views.Admin.HtmlModalView()
    window.masterView=new Joygen.Views.Admin.MasterView
    window.fieldView=new Joygen.Views.Admin.FieldView
      el:$("#field")
    window.toolbarView=new Joygen.Views.Admin.ToolbarView
      el:$("#toolbar")
    window.propertiesView=new Joygen.Views.Admin.PropertiesView
      el: $("#properties-container")
    # window.floatingToolbarView=new Joygen.Views.Admin.FloatingToolbarView
    #   el: $("#floating-toolbar")
    window.reloadView=new Joygen.Views.Admin.ReloadView
      el: $("#reload")
    window.testingView=new Joygen.Views.Admin.TestingView
      el: $("#test-link")
    window.helpMenuView=new Joygen.Views.Admin.HelpMenuView
      el: $("#help-menu")
    helpMenuView.render()

  index: (pid,eid) ->
    window.loading=true
    window.editId=(if eid=="0" then pid else eid)
    window.parentId=pid
    masterView.loadProperties()
    if @oldId!=parentId
      fieldView.id=parentId
      if masterView.needLoad(parentId)
        masterView.setLoadOverlay()
        masterView.loadCollection(parentId)
      else
        masterView.renderViews()
      @oldId=parentId
