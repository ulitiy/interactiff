class Joygen.Models.Message extends Joygen.Models.Block
  modelName: "message"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Message"
      body: I18n.t("admin.message.new")
    )
  icon: "/assets/admin/icons/16/197.png"
  isTarget: true
