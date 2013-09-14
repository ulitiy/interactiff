window.gridStep=5
$ ->
  jsPlumb.silent=false
  jsPlumb.allowDetach=false
  jsPlumb.importDefaults
    Container: $("#field")
    PaintStyle:
      lineWidth:3.6
      strokeStyle:"#303030"
    EndpointStyle:
      radius:5
      fillStyle:"#303030"
      hoverStyle: "endpointHover"
    HoverPaintStyle:
      strokeStyle:"#89C27F"
      lineWidth:4.2
    Connector: ["Bezier"]#Flowchart, Straight, StateMachine, Bezier
    ConnectionOverlays:[["Arrow", {foldback:0.4, width: 7, length: 15, location:1}]]
    MaxConnections:-1
