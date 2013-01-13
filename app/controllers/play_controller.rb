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
    @task=Task.where(id:params[:task_id]).first #not to return nil
    @handler=EventHandler.new(user: current_user, game: @game, task: @task)
    if @task.nil? || @task.game_id!=@game.id || !@handler.task_given? #если нет такого задания или если задание не в игре или если задание не дано
      @task=@handler.play_tasks.find{ |t| !t.passed } || @handler.play_tasks.first #первое не пройденное или первое
      #TODO: протестировать если все задания пройдены, что перенаправляется с URL игры
      redirect_to play_show_url(game_id: @game.id, task_id: @task.id) and return if @task
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
    redirect_to play_show_url(game_id: @game.id, task_id: @task.id)
  end

  # Set flash messages due to current changes
  def set_flash
    if @handler.flush.game_passed?
      flash[:notice]=t("play.notice.game_passed")
      redirect_to play_show_url(game_id: @game.id)
      return
    elsif @handler.task_passed?
      @task=@handler.current_tasks.first
      flash[:notice]=t("play.notice.task_passed")
    # elsif @fired_events.present?
    #   flash[:notice]=t("play.notice.fired_events")
    else
      flash[:alert]=t("play.alert.no_events")
    end
  end
end
