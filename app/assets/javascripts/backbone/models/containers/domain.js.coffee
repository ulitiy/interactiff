class Joygen.Models.Domain extends Joygen.Models.Block
  modelName: "domain"
  defaults: ->
    _.extend({}, Joygen.Models.Block.prototype.defaults(),
      type: "Domain"
      name: I18n.t("admin.domain.new")
      main_host_id: null
    )
  container: -> true
  tools: ["Host","Game"]
  icon: "/assets/admin/icons/16/045.png"

  hosts: =>
    id=@get("id")
    @collection.filter (block)->
      block.get("parent_id")==id && block.get("type")=="Host"

