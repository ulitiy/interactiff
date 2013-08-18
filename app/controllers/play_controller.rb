# Controller for playing the quest
class PlayController < ApplicationController
  layout false
  load_resource :game, except: :submit
  before_filter -> { authorize! :play, @game }, except: :submit
  before_filter :set_cache_buster, only: :show
  helper_method :user

  # after_filter :set_access_control_headers #CORS

  # def set_access_control_headers
  #   headers['Access-Control-Allow-Origin'] = '*'
  #   headers['Access-Control-Request-Method'] = '*'
  # end

# Вначале проверяется, есть ли юзер.
# В сабмите если нет - гость (+урл)
# В гейме и шоу – не создавать, выдавать 4all

  def use_url_session?
    params[:ust].present?
  end

  # get play user
  def user
    @user||=use_url_session? ? url_session_user : current_user
  end

  # get play user or set if necessary
  def set_user
    @user||=(use_url_session? ? url_session_user : current_user) || create_guest
  end

  def url_session_user
    Guest.get_by_token(params[:ust])
  end

  def url_options
    return super.merge ust: user ? user.token : "embed" if use_url_session?
    super
  end

  # Display current state of player in game/task
  def show
    @task=Task.where(id: params[:task_id]).first #not to return nil
    @handler=EventHandler.new(user: user, game: @game, task: @task)
    if @task.nil? || @task.game_id!=@game.id || !@handler.task_given? #если нельзя показать запрошенное задание
      redirect_to play_game_url(game_id: @game.id)
    elsif r=@task.get_redirect_event(user: @user)
      redirect_to r.block.url_with_vars game: @game, task: @task, user: @user, handler: @handler
    elsif File.exists?(Rails.root.join("app", "views", params[:controller],"#{@task.title}.html.erb"))
      render "play/#{@task.title}"
    elsif File.exists?(Rails.root.join("app", "views", params[:controller],"#{@game.title}.html.erb"))
      render "play/#{@game.title}"
    else
      render "play/show"
    end
  end

  # Main entry point for the game
  def game
    flash.keep
    @handler=EventHandler.new(user: user, game: @game, task: @task)
    if !@handler.game_started?
      @start_time=@game.game_started_block.time
      render "play/not_started" # if stale? etag: [@start_time,"play/not_started"].join #не кэшируем из-за синхронизации времени
      # fresh_when etag: [@start_time,"play/not_started"].join, public: true
    elsif @handler.game_passed?
      render "play/win"
    else
      @task=@handler.current_tasks.first
      if @task #если есть первое не пройденное
        redirect_to play_show_url(game_id: @game.id, task_id: @task.id) and return #то перенаправить туда
      else
        render "play/no_tasks"
      end
    end
  end

  # Submit input from player
  def submit
    @task=Task.find(params[:task_id])
    @game=@task.game
    authorize! :play, @game
    @handler=EventHandler.new(user: set_user, game: @game, task: @task)
    @user.save!(:validate => false) if use_url_session?
    CriticalSection.synchronize @game.id do
      begin
        @fired_events=@handler.input(params[:input]).to_a
      rescue Exception => e
        render :nothing => true, :status => 500
        return
      end
      set_flash
    end
  end

  def back
    tgs=@game.descendant_events_of(type: "TaskGiven", user: user)
    ltg=tgs.sort_by { |tg| tg.time }.last
    events=@game.descendant_events.where(user: user).where(time: { "$gt"=> ltg.time })
    if events.count>0
      events.delete_all
    elsif tgs.count>1
      ltg.delete
      return back
    end
    redirect_to play_game_url(game_id: @game.id)
  end

  # Set flash messages due to current changes
  def set_flash
    flash[:messages]=@fired_events.find_all { |e| e.block_type.in? Message.descendant_types }.map do |e|
      {message:e.block.message_with_vars(@handler.options), message_type: e.block.message_type}
    end.compact
    if @fired_events.find { |e| e.block_type=="TaskPassed" }
      redirect_to play_game_url(game_id: @game.id)
    elsif @task.show_wrong_answer
      flash[:alert]=t("play.alert.no_events")
      redirect_to play_show_url(game_id: @game.id, task_id: @task.id)
    else
      redirect_to play_show_url(game_id: @game.id, task_id: @task.id)
    end
  end
end
