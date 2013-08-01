$(function(){
  var topOffsetTick = parseInt($(".tick").css('top'));
  var teamsOffset = parseInt($(".teamnames").css('left'));
  $(".viewport").scroll(function(){
    $('.teamnames').css({
          'left': $(this).scrollLeft() + teamsOffset,
          'height': $('.viewport').height() + $('.viewport').scrollTop()
      });
    $('.tick').css({
          'top': $(this).scrollTop() + topOffsetTick + 20
      });
    $('.tick.now').css({
        'top': $(this).scrollTop() + topOffsetTick
    });
    $('.timeline-bar, .zakrivashka').css({
        'top': $(this).scrollTop() + topOffsetTick - 40
    });
    $('.zakrivashka').css({
        'left': $(this).scrollLeft() + teamsOffset
    });
  });
});
