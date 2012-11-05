$(window).unload ->
  layoutState.save 'adminLayout', null
    #domain: "lvh.me"
    path: "/admin/"
  layoutState.save 'eastLayout', null
    #domain: "lvh.me"
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
  east__onresize: "eastLayout.resizeAll"

eastSettings=
  minSize: 100
  maxSize: 600
  south__size:300
  closable: false
  south__resizerCursor: "row-resize"
  spacing_open: 3

$ ->
  window.adminLayout=$('body').layout $.extend(layoutSettings,layoutState.load('adminLayout'))
  window.eastLayout=$('#east').layout $.extend(eastSettings,layoutState.load('eastLayout'))
  window.centerLayout=$("#center").layout
    closable:false
    spacing_open:1
    resizable:false
    north__size:30