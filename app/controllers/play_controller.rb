class PlayController < ApplicationController
  layout false
  # before_filter :authenticate_user!

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
    @play_tasks=@handler.play_tasks #TODO: везде проверить сортировку по y,x!!!
    @task=Task.where(id:params[:task_id]).first
    @handler.options[:task]=@task
    if @task.nil? || @task.game_id!=@game.id || !@handler.task_given? #если нет такого задания или если задание не в игре или если задание не дано
      @task=@play_tasks.find{ |t| !t.passed }
      redirect_to play_show_url(game_id: @game.id, task_id: @task.id) and return if @task
    end
    @hint_events=@handler.hint_events
    @hints_given=@handler.hints_given
    @answers=@handler.task_answers
  end

  def submit
    @task=Task.find(params[:task_id])
    @game=@task.game
    @handler=EventHandler.new(user: current_user, game: @game, task: @task)
    CriticalSection.synchronize @game.id do
      @fired_events=@handler.input(params[:input])
      @handler.flush
      if @handler.game_passed?
        flash[:notice]=t("play.notice.game_passed")
        redirect_to play_show_url(game_id: @game.id)
        return
      elsif @handler.task_passed?
        @task=@handler.current_tasks.first
        flash[:notice]=t("play.notice.task_passed")
      elsif @fired_events.present?
        flash[:alert]=t("play.alert.no_events") #выбран неверный ответ
        # flash[:notice]=t("play.notice.fired_events")
      else
        flash[:alert]=t("play.alert.no_events")
      end
    end
    redirect_to play_show_url(game_id: @game.id, task_id: @task.id)
  end
end
