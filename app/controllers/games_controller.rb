# CRUD game controller for an author interface
class GamesController < InheritedResources::Base
  actions :index, :show, :create, :destroy
  load_resource except: :index
  authorize_resource
  layout "quests", only: [ :index ]

  # makes the user member of the game
  def join
    @game||=Game.find(params[:id])
    authorize! :join, @game
    current_user.member_of_games << @game
    #flash[:notify]=t "game.joined"
    redirect_to play_show_url(game_id: @game.id)
  end

  # IR collection definition for actions
  def collection
    @games||=can?(:manage, Domain.first) && params[:all] ? Game.desc(:updated_at) : current_user.games
  end

  def reset
    @game.reset
    redirect_to games_url
  end
  def create
    @game = Game.new
    @game.name = params[:game][:name]
    @game.category = params[:game][:category]
    @game.cover = params[:game][:cover]
    @game.parent = current_domain
    current_user.engine_roles.create! access: :manage_roles, block: @game
    authorize!(:create,@game)
    @game.save!
    redirect_to main_app.admin_path(parent_id: @game.id, select_id: 0)
  end
end
