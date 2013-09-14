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
Mousetrap.bind 'shift+up', ->
  Joygen.Views.Admin.BlockView.prototype.move(0,-10*gridStep)
  false
Mousetrap.bind 'shift+down', ->
  Joygen.Views.Admin.BlockView.prototype.move(0,10*gridStep)
  false
Mousetrap.bind 'shift+left', ->
  Joygen.Views.Admin.BlockView.prototype.move(-10*gridStep,0)
  false
Mousetrap.bind 'shift+right', ->
  Joygen.Views.Admin.BlockView.prototype.move(10*gridStep,0)
  false
Mousetrap.bind 'enter', ->
  if $("*:focus").length==0
    propertiesView.setFocus()
    return false
  else
    if selectedSourceView?
      selectedSourceView.hideForm()
      return false
Mousetrap.bind ['ctrl+s', 'command+s'], (e)->
  $("*:focus").blur()
  selectedSourceView?.hideForm()
  propertiesView.save()
  false
Mousetrap.bind 'esc', ->
  if $("*:focus").length==0
    fieldView.blurSelect()
  else
    $("*:focus").blur()
Mousetrap.stopCallback=(e, element, combo) ->
    if combo=="ctrl+s" || combo=="command+s" || combo=="esc" || combo=="enter"
      return false;
    return element.tagName == 'INPUT' || element.tagName == 'SELECT' || element.tagName == 'TEXTAREA' || (element.contentEditable && element.contentEditable == 'true');



# Mousetrap.bind ['q','й','Q','Й'], -> floatingToolbarView.show() if editBlock!=parentBlock

$ ->
  window.kinetic=false
  $("#field").kinetic
    filterTarget: (t)->
      t
  $("#field").kinetic("detach")
Mousetrap.bind 'space',
  ->
    if $("*:focus").length==0
      fieldView.selectableDisable()
      $("#field").kinetic("attach")
      false
  , "keydown"
Mousetrap.bind 'space',
  ->
    if $("*:focus").length==0
      fieldView.selectableEnable()
      $("#field").kinetic("detach")
      false
  , "keyup"
