module EmbedHelper

  def embed_code game_id
<<STR
<script type="text/javascript">
interactiff_domain = "interactiff.net";
interactiff_id = "#{game_id}";
interactiff_width = 600;
interactiff_height = 600;
</script>
<script type="text/javascript" src="#{[request.protocol,current_host.name,request.port_string].join}/assets/embed.js"></script>
STR
  end

end