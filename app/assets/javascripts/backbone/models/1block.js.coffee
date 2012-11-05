class Joygen.Models.Block extends Backbone.Model
  paramRoot: 'block' #это нужно, чтобы параметры, передаваемые на сервер оборачивались рут-элементом с этим именем
  defaults: ->
    type: "Block"
    x: Math.round(Math.random()*50)*10
    y: Math.round(Math.random()*30)*10
    parent_id: null
    modelChanged:false

  initialize: ->
    @on "change",=>
      ca=@changedAttributes()
      delete ca["caption"]
      @modelChanged=true if Object.keys(ca).length
    @on "sync",=>
      @modelChanged=false
    @on "change:name", => @set "caption": @getCaption()
    @on "change:body", => @set "caption": @getCaption()
    @on "change:title": => @set "caption": @getCaption()
    setTimeout => @set "caption": @getCaption()
    ,0

  modelName: "block"

  deletable: true

  getCaption: ->
    n=@get("name")||@get("body")
    return n if n? && n.length <= 20
    n.substr(0,15)+"..."

  endpointCaption: ->
    @get("title")||@getCaption()

  setPosition: (position)->
    @save
      "x": Math.round(position.left/gridStep)*gridStep #патчим глюки с массовым дрэгом
      "y": Math.round(position.top/gridStep)*gridStep
  url: ->
    return "/blocks" if @isNew()
    "/blocks/#{@id}"
  icon: "/assets/admin/icons/16/050.png"
  toolName: -> I18n.t("admin.#{@modelName}.tool")
  outTools: ->
    _.filter @tools, (tool)->
      t=Joygen.Models[tool].prototype
      t.isSource || t.container
  adminPath: ->
    "#{@id}/0"
  children: ->
    @collection.children(@id)
  parent: ->
    @collection.parent(@id)
  # destroy: (options) =>
  #   item.destroy() for item in @children()
  #   item.destroy() for item in @outRelations()
  #   item.destroy() for item in @inRelations()
  #   super options





  getContainerSources: ->
    arr=_.filter @children(), (block)->
      block.isContainerSource?
    _.sortBy arr, (block)->
      block.get("y")+block.get("x")/10000 #таким образом получаем первичную сортировку по y, вторичную по x
  getContainerTargets: ->
    arr=_.filter @children(), (block)->
      block.isContainerTarget?
    _.sortBy arr, (block)->
      block.get("y")+block.get("x")/10000

  outRelations: ->
    relationsCollection.filter (relation)=>
      relation.get("from_id")==@id
  inRelations: ->
    relationsCollection.filter (relation)=>
      relation.get("to_id")==@id


window.rootBlock=new Joygen.Models.Block
    id:0
    name:I18n.t("admin.path.root")
rootBlock.adminPath= -> "0/0"
rootBlock.icon="/assets/admin/icons/16/092.png"
rootBlock.tools=["Domain"]
