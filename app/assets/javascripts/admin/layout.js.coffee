$.layout.defaults.stateManagement.cookie.path="/"
$.layout.defaults.stateManagement.cookie.expires="90"
$.layout.defaults.stateManagement.name="adminLayout"
layoutSettings=
  useStateCookie: true
  minSize: 150
  maxSize: 400
  east__resizerCursor: "col-resize"
  west__resizerCursor: "col-resize"
  west__minSize: 33
  west__maxSize: 200
  west__size: 165
  east__size: 250
  spacing_open: 5
  togglerLength_open: 35
  togglerLength_closed: 35
  togglerContent_open: '<div class="triangle-left"></div>'
  togglerContent_closed: '<div class="triangle-right"></div>'
  closable: !$.browser.mobile

$ ->
  window.adminLayout=$('#content').layout layoutSettings
