class Joygen.Models.RedirectBlock extends Joygen.Models.Block
  modelName: "redirect_block"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "RedirectBlock"
      name: I18n.t("admin.redirect_block.tool")
      url: "http://interactiff.net/some_page"
    )
  icon: "/assets/admin/icons/16/094.png"
  isTarget: -> true
