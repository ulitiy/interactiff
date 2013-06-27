$ ->
  window.loadingOverlay=$('<div class="overlay"></div>').
  hide().appendTo("body").html(JST["backbone_admin/templates/admin/loading"]())
