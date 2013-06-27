class Joygen.Models.RequestBlock extends Joygen.Models.Block
  modelName: "request_block"
  mainField: "url"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "RequestBlock"
      name: I18n.t("admin.request_block.tool")
      url: "http://interactiff.net/some_page"
    )
  icon: "/assets/admin/icons/16/146.png"
  isTarget: -> true
