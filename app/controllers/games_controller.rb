# CRUD game controller for an author interface
class GamesController < InheritedResources::Base
  actions :index, :show, :create, :destroy
  load_resource except: :index
  authorize_resource
  layout "admin", only: [ :index,:timeline,:embed ]

  # makes the user member of the game
  # def join
  #   @game||=Game.find(params[:id])
  #   authorize! :join, @game
  #   current_user.member_of_games << @game
  #   #flash[:notify]=t "game.joined"
  #   redirect_to play_show_url(game_id: @game.id)
  # end

  # IR collection definition for actions
  def collection
    @games||=can?(:manage, Domain.first) && params[:all] ? Game.desc(:updated_at) : current_user.games
  end

  # Page for testing IFrame
  def iframe
    render layout: false
  end

  # Page with embedding code
  def embed
  end

  # Delete all events and start game
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

  def timeline
    @scale=(params[:scale] || 0.05).to_f
    @timeline = @game.timeline_sorted
    @first_time = @game.timeline_events.last.try :time
    render nothing: true, status: 404 and return if @first_time.nil?
    @last_time = @game.timeline_events.first.try :time
    @timeline_width = (@last_time-@first_time)*@scale+200 #1 час - 100 пикселей
    @tick=[15,30,60,120,300,600,900,1800,3600,3600*2,3600*6,3600*12,3600*24,3600*24*2,3600*24*7].find { |i| i*@scale>=100 && i*@scale<=400 }
    @tick_px=(@tick*@scale).round
  end

  #ПЕРЕНЕСТИ СЮДА ADMIN, сменить урл на builder, м.б. сделать дочерний id и т.п.?
end
