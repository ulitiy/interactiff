$ ->
  window.loadingOverlay=$('<div class="overlay"></div>').
  hide().appendTo("body").html(JST["backbone/templates/admin/loading"]())
