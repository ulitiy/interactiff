class Joygen.Models.Answer extends Joygen.Models.Block
  modelName: "answer"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Answer"
      name: I18n.t("admin.answer.new")
    )
  icon: "/assets/admin/icons/16/102.png"
  isSource: true
