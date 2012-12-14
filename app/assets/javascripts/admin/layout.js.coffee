$(window).unload ->
  layoutState.save 'adminLayout', null
    path: "/admin/"

layoutSettings=
  useStateCookie: true
  minSize: 100
  maxSize: 400
  east__resizerCursor: "col-resize"
  west__resizerCursor: "col-resize"
  west__minSize: 33
  west__maxSize: 200
  west__size: 100
  east__size: 100
  center__onresize: "centerLayout.resizeAll"


$ ->
  window.adminLayout=$('body').layout $.extend(layoutSettings,layoutState.load('adminLayout'))
  window.centerLayout=$("#center").layout
    closable:false
    spacing_open:1
    resizable:false
    north__size:30