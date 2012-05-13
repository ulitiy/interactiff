#ОБЯЗАТЕЛЬНО СДЕЛАТЬ ТОЛЬКО ОДНО СОХРАНЕНИЕ В ЕДИНИЦУ ВРЕМЕНИ
#сделать чтобы при удалении контейнеров, удалялись связи

class Joygen.Collections.BlocksCollection extends Backbone.Collection
  model: Joygen.Models.Block
  # url: "/blocks"
  # initialize:  ->
  #   @storage = new Offline.Storage('blocks', this, keys: {parent_id: this, game_id: this, task_id: this})

  parse: (resp)->
    _(resp).map (attrs) ->
      new Joygen.Models[attrs.type](attrs)
  path: (id)=>
    b=@get(id)
    return [] unless b?

    window.parentTask=b if b.get('type')=="Task"
    window.parentGame=b if b.get('type')=="Game"

    return [b] unless b.get("parent_id")?
    @path(b.get("parent_id")).concat([b])

  parent: (id)=>
    @find (item)-> item.id==id

  children: (id)=>
    if id=="0"
      return @filter (block)->
        block.get("type")=="Domain"
    @filter (block)->
      block.get("parent_id")==id
