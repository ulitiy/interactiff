$.fn.css_position=->
  return {
    top: parseInt this.css("top")
    left: parseInt this.css("left")
  }