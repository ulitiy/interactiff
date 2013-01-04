$(window).unload ->
  layoutState.save 'adminLayout', null
    path: "/admin/"

layoutSettings=
  useStateCookie: true
  minSize: 150
  maxSize: 400
  east__resizerCursor: "col-resize"
  west__resizerCursor: "col-resize"
  west__minSize: 33
  west__maxSize: 200
  west__size: 100
  east__size: 100
  spacing_open: 5
  togglerLength_open: 35
  togglerLength_closed: 35
  togglerContent_open: '<div class="triangle-left"></div>'
  togglerContent_closed: '<div class="triangle-right"></div>'

$ ->
  window.adminLayout=$('#content').layout $.extend(layoutSettings,layoutState.load('adminLayout'))
