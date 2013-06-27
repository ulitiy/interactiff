Joygen.Views.Admin ||= {}

class Joygen.Views.Admin.FloatingToolView extends Backbone.View

  template: JST["backbone_admin/templates/admin/floating_tool"]

  events:
    click:"createBlock"

  tagName: "div"
  className: "tool"

  createBlock: =>
    block=new Joygen.Models[@options.tool]()
    block.set "parent_id":parentId if @options.tool!="Domain"
    masterCollection.create(block)

  render: (num)=>
    proto=Joygen.Models[@options.tool].prototype
    @$el.html @template({model:proto,num:@options.num})
    @$el.attr("title",I18n.t('admin.'+proto.modelName+'.hint'))
    this
