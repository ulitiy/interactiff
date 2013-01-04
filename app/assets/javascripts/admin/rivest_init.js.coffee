rivets.configure
  adapter:
    subscribe: (obj, keypath, callback)->
      obj.on('change:' + keypath, callback)
    unsubscribe: (obj, keypath, callback)->
      obj.off('change:' + keypath, callback)
    read: (obj, keypath)->
      obj.get(keypath)
    publish: (obj, keypath, value)->
      obj.set(keypath, value)

# https://github.com/mikeric/rivets/issues/75