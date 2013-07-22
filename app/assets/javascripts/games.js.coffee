$ ->
  load_preview = (input) ->
    if input.files and input.files[0]
      reader = new FileReader()
      reader.onload = (e) ->
        types = /(\.|\/)(jpe?g|png)$/i
        file = input.files[0]
        if types.test(file.type) or types.test(file.name)
          img = new Image()
          img.onload = ->
            $('.game_cover label').css
              'background-image':"url(#{e.target.result})"
              'background-size': 'cover'
          img.src = e.target.result
        else
          alert 'Разрешено только jpg, png'
      reader.readAsDataURL input.files[0]
  $("#new-game").click ->
    $.post "/blocks", {block: {type: "Game"}}, (data) ->
      window.location = "/#{locale}/admin/#{data.id}/0"
    , "json"
  $('#game_cover').live 'change', ->
    load_preview this
  $('[data-toggle="new-quest"]').live 'click', ->
    $(this).toggleClass 'active'
    $('#nq').toggleClass 'active'
