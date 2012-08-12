class PlayController < ApplicationController
  layout "play"
  before_filter :authenticate_user!

  # ЕЩЕ КРАЙНЕ ВАЖНО ПРОВЕРИТЬ ДВОЙНОЕ ЗАЖИГАНИЕ БЛОКОВ. ИЛИ ВОВСЕ ЕГО УБРАТЬ ЧЕРЕЗ IS_HIT? HOT?
  # сделать отслеживание возникающих событий. Например, писать в браузер айдишник последнего ивента или его время
  # Частичное сохранение-откат??? Может решить через шаблоны?
  # ОБЯЗАТЕЛЬНО ПОСТАВИТЬ ИНФА НА САЙТ!!!
  # для оптимизации - предзагрузка всей игры целиком, чтобы не таскать из БД каждый блок отдельно
  # сделать отдельные интерфейсы под апи для инфов, линейной/штурмовой игры
  # обязательная установка переменной из части ответа (использовать скобки)

  def show
    @game=Game.find(params[:game_id])
    @handler=EventHandler.new(user: current_user, game: @game)
    @tasks_available=@handler.tasks_available #TODO: везде проверить сортировку по y,x!!!
    begin
      @task=Task.find(params[:task_id])
      raise if @task.game_id!=@game.id
    rescue
      @task=@tasks_available.first
      redirect_to play_show_url(game_id: @game.id, task_id: @task.id) if @task
    end
  end

  def submit
    @task=Task.find(params[:task_id])
    @game=@task.game
    @handler=EventHandler.new(user: current_user, game: @game, task: @task)
    CriticalSection.synchronize @game.id do
      @fired_events=@handler.input(params[:input])
      if @handler.task_passed?
        @task=@handler.tasks_available.first
        flash[:notice]=t("play.task_passed")
      elsif @fired_events.present?
        flash[:notice]=t("play.fired_events")
      else
        flash[:alert]=t("play.no_events")
      end
    end
    redirect_to play_show_url(game_id: @game.id, task_id: @task.id)
  end
end
