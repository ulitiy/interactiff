$ ->
  e=$("#refreshed")
  unless $("body").hasClass("not-started")
    if(e.val()=="no")
      e.val("yes")
    else
      e.val("no")
      $("body").html("")
      location.reload()
