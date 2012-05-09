Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.ToolView extends Backbone.View

  template: JST["backbone/templates/admin/tool"]

  events:
    click:"createBlock"

  tagName: "div"
  className: "tool"

  createBlock: =>
    block=new Joygen.Models[@options.tool]()
    block.set "parent_id":parentId if @options.tool!="Domain"
    #block.save()
    #masterCollection.add(block)
    masterCollection.create(block)

  render: =>
    proto=Joygen.Models[@options.tool].prototype
    $(@el).html @template(proto)
    $(@el).attr("title",I18n.t('admin.'+proto.modelName+'.hint'))
    this
