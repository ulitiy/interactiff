$ ->
  if $("#counter")?
    window.startTime=new Date $("#counter").data("time")
    cut=(i)->
      ("00"+i).slice(-2)
    set_time=->
      now=new Date()
      diff=(startTime-now)/1000 + 2
      if diff<1
        location.reload()
      days = Math.floor(diff / 86400);
      hours = Math.floor(diff / 3600) % 24;
      minutes = Math.floor(diff / 60) % 60;
      seconds = Math.floor(diff % 60)
      $(".count.days").html(days)
      $(".count.hours").html(cut(hours))
      $(".count.minutes").html(cut(minutes))
      $(".count.seconds").html(cut(seconds))
    set_time()
    setInterval set_time, 999
