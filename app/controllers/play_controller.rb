# Controller for playing the quest
class PlayController < ApplicationController
  layout false
  # load_and_authorize_resource #TODO:!!!!!!!!!!!!!!!!!!!!!           СМОТРИ СЮДА БЛЕАТЬ              !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  # TODO: сделать отслеживание возникающих событий. Например, писать в браузер айдишник последнего ивента или его время
  # ОБЯЗАТЕЛЬНО ПОСТАВИТЬ ИНФА НА САЙТ!!!
  # для оптимизации - предзагрузка всей игры целиком, чтобы не таскать из БД каждый блок отдельно

  # Display current state of player in game/task
  def show
    @game=Game.find(params[:game_id])
    @task=Task.where(id: params[:task_id]).first #not to return nil
    @handler=EventHandler.new(user: current_user, game: @game, task: @task)
    if @task.nil? || @task.game_id!=@game.id || !@handler.task_given? #если нельзя показать запрошенное задание
      redirect_to play_game_url(game_id: @game.id)
    end
  end

  def game
    @game=Game.find(params[:game_id])
    @handler=EventHandler.new(user: current_user, game: @game, task: @task)
    if !@handler.game_started?
      @start_time=@game.children.where(_type: "GameStarted").first.time
      render "play/not_started" # if stale? etag: [@start_time,"play/not_started"].join
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
    @handler=EventHandler.new(user: current_user, game: @game, task: @task)
    CriticalSection.synchronize @game.id do
      @fired_events=@handler.input(params[:input])
      set_flash
    end
  end

  # Set flash messages due to current changes
  def set_flash
    # if @handler.flush.game_passed?
    #   redirect_to play_game_url(game_id: @game.id)
    #   return
    # elsif
    if @handler.flush.task_passed?
      flash[:notice]=t("play.notice.task_passed")
      redirect_to play_game_url(game_id: @game.id)
      return
    # elsif @fired_events.present?
    #   flash[:notice]=t("play.notice.fired_events")
    else
      flash[:alert]=t("play.alert.no_events")
      redirect_to play_show_url(game_id: @game.id, task_id: @task.id)
    end
  end
end
