window.gridStep=5
$(window).unload ->
  jsPlumb.unload()
$ ->
  jsPlumb.silent=false
  jsPlumb.allowDetach=false
  jsPlumb.importDefaults
    Container: $("#field")
    PaintStyle:
      lineWidth:3.6
      strokeStyle:"#555"
    EndpointStyle:
      radius:5
      fillStyle:"#555"
      hoverStyle: "endpointHover"
    HoverPaintStyle:
      strokeStyle:"#F00"
      lineWidth:4.2
    Connector: ["Flowchart"]#Flowchart, Straight, StateMachine, Bezier
    ConnectionOverlays:[["Arrow", {foldback:0.4, width: 7, length: 15, location:1}]]
    MaxConnections:-1
