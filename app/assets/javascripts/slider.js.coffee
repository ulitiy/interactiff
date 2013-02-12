$ ->
  $('#slider').carousel({interval:6000})

  $('#carousel-nav a').click (q)->
    q.preventDefault()
    targetSlide = $(this).attr('data-to')
    $('#slider').carousel(parseInt(targetSlide)-1)
    $(this).addClass('active').siblings().removeClass('active')

  $('#slider').bind 'slid', ->
    item = $('#slider .carousel-inner .item.active')
    $('#carousel-nav a').removeClass('active')
    index = item.index()+1
    $('#carousel-nav a:nth-child(' + index + ')').addClass('active')
