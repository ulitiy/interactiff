class Joygen.Models.Block extends Backbone.Model
  paramRoot: 'block' #это нужно, чтобы параметры, передаваемые на сервер оборачивались рут-элементом с этим именем
  defaults: ->
    type: "Block"
    x: parseInt(($("#field").scrollLeft()+Math.round(Math.random()*500))/10)*10
    y: parseInt(($("#field").scrollTop()+Math.round(Math.random()*300))/10)*10
    parent_id: null
    container_source: false
    container_target: false

  modelName: "block"

  deletable: true
  @dirty: false

  initialize: ->
    @on "change", =>
      @dirty=true

  caption: ->
    @get("name")||@get("body")

  short_caption: ->
    n=@caption()||@get("name")||""
    n=n.replace(/(<([^>]+)>)/ig,"") #strip html
    return n if n? && n.length <= 20
    n.substr(0,17)+"..." if n?

  endpointCaption: ->
    @get("title") || @short_caption()

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
      t.isSource?() || t.container
  adminPath: ->
    "#{@id}/0"
  children: ->
    @collection.children(@id)
  parent: ->
    @collection.parent(this)
  parent_name: ->
    @parent().get("name")






  getContainerSources: ->
    arr=_.filter @children(), (block)->
      block.get("container_source")
    _.sortBy arr, (block)->
      block.get("y")+block.get("x")/10000 #таким образом получаем первичную сортировку по y, вторичную по x
  getContainerTargets: ->
    arr=_.filter @children(), (block)->
      block.get("container_target")
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
