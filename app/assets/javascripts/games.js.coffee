$ ->
  $("#new-game").click ->
    $.post "/blocks", {block: {type: "Game"}}, (data)->
      window.location="/admin/#{data.id}/0"
    , "json"
