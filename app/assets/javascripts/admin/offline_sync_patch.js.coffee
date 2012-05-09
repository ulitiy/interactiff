Offline.Storage.prototype.replaceKeyFields= (item, method) ->
  if Offline.onLine()
    item = item.attributes if item.attributes
    for field, collection of @keys
      replacedField = item[field]
      if !/^\w{8}-\w{4}-\w{4}/.test(replacedField) or method isnt 'local'
        newValue = if method is 'local'
          wrapper = new Offline.Collection(collection)
          wrapper.get(replacedField)?.id
        else
          ref_item=collection.get(replacedField)
          if ref_item?
            item.dirty1=true
            ref_item.get('sid')
        item[field] = newValue unless _.isUndefined(newValue)
  return item


Offline.Sync.prototype.reset= (arr)->
  @storage.clear()
  @collection.items.reset([], silent: true)
  @collection.items.create(item, local: true, silent: true) for item in arr
  @collection.items.trigger('reset')

Offline.Sync.prototype.push= (options)->
  window.inPush=0
  this.pushItem(item,options) for item in @collection.dirty()
  this.flushItem(sid) for sid in @storage.destroyIds.values

Offline.Sync.prototype.pushItem= (item,options) ->
  @storage.replaceKeyFields(item, 'server')
  #localId = item.id
  #delete item.attributes.id
  [method, item.id] = if item.get('sid') is 'new' then ['create', null] else ['update', item.attributes.sid]
  window.inPush++
  this.ajax method, item,
    success: (response, status, xhr) =>
      item.set(sid: response.id) if method is 'create'
      item.set dirty1:false if options?.inner
      item.save {dirty: false}, {local: true}
      window.inPush--
      if inPush is 0
        this.pushItem(item1,{inner_success: options?.success, inner: true}) for item1 in @collection.items.where(dirty1: true)
      options?.inner_success?()
    #complete: =>
