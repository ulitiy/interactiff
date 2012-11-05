class GamesController < InheritedResources::Base
  actions :index, :show, :create, :destroy
  load_and_authorize_resource

  # makes the user member of the game
  def join
    @game=Game.find(params[:id])
    authorize! :join, @game
    current_user.member_of_games<<@game
    #flash[:notify]=t "game.joined"
    redirect_to play_show_url(game_id: @game.id)
  end

  def collection
    @games||=current_domain.games
  end
end
