$ ->
  e=$("#refreshed")
  if $("body").hasClass("show")
    if(e.val()=="no")
      e.val("yes")
    else
      e.val("no")
      $("body").html("")
      location.reload()
