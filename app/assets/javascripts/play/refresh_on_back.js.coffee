$ ->
  e=$("#refreshed")
  if(e.val()=="no")
    e.val("yes")
  else
    e.val("no")
    $("body").html("")
    location.reload()