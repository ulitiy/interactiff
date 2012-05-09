class Joygen.Models.Host extends Joygen.Models.Block
  modelName: "host"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Host"
      name: Math.round(Math.random()*10000)+"."+I18n.t("admin.host.second_level")
    )
  icon: "/assets/admin/icons/16/094.png"
