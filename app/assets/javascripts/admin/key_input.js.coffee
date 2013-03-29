Mousetrap.bind ['backspace','del'], ->
  fieldView.deleteKey()
  false
Mousetrap.bind 'up', ->
  Joygen.Views.Admin.BlockView.prototype.move(0,-gridStep)
  false
Mousetrap.bind 'down', ->
  Joygen.Views.Admin.BlockView.prototype.move(0,gridStep)
  false
Mousetrap.bind 'left', ->
  Joygen.Views.Admin.BlockView.prototype.move(-gridStep,0)
  false
Mousetrap.bind 'right', ->
  Joygen.Views.Admin.BlockView.prototype.move(gridStep,0)
  false
Mousetrap.bind 'space', ->
  if $("*:focus").length==0
    propertiesView.setFocus()
    false
Mousetrap.bind ['ctrl+s', 'command+s'], (e)->
  $("*:focus").blur()
  propertiesView.save()
  false
Mousetrap.bind 'esc', ->
  if $("*:focus").length==0
    router.navigate (parentBlock||rootBlock).adminPath(),
      trigger:true
      replace:true
    $(".ui-selected").removeClass("ui-selected")
  else
    $("*:focus").blur()
Mousetrap.stopCallback=(e, element, combo) ->
    if combo=="ctrl+s" || combo=="command+s" || combo=="esc"
      return false;
    return element.tagName == 'INPUT' || element.tagName == 'SELECT' || element.tagName == 'TEXTAREA' || (element.contentEditable && element.contentEditable == 'true');

# Mousetrap.bind ['q','й','Q','Й'], -> floatingToolbarView.show() if editBlock!=parentBlock
#Mousetrap.bind ['1','2','3','4','5'], -> alert('')
#ctrl+s