class Joygen.Models.Output extends Joygen.Models.Block
  modelName: "output"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Output"
      name: I18n.t("admin.output.new")
      container_source: true
    )
  icon: "/assets/admin/icons/16/131.png"
  isTarget: -> true
