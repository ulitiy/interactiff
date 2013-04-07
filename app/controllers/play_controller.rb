# Controller for playing the quest
class PlayController < ApplicationController
  layout false
  load_resource :game, except: :submit
  before_filter :auth, except: :submit

  def auth
    authorize! :play, @game
  end

  # TODO: сделать отслеживание возникающих событий. Например, писать в браузер айдишник последнего ивента или его время
  # ОБЯЗАТЕЛЬНО ПОСТАВИТЬ ИНФА НА САЙТ!!!
  # для оптимизации - предзагрузка всей игры целиком, чтобы не таскать из БД каждый блок отдельно

  # Display current state of player in game/task
  def show
    @task=Task.where(id: params[:task_id]).first #not to return nil
    @handler=EventHandler.new(user: current_user, game: @game, task: @task)
    if @task.nil? || @task.game_id!=@game.id || !@handler.task_given? #если нельзя показать запрошенное задание
      redirect_to play_game_url(game_id: @game.id)
    elsif r=@task.get_redirect_event(user: current_user)
      redirect_to r.block.url_with_vars game: @game, task: @task, user: current_user, handler: @handler
    elsif File.exists?(Rails.root.join("app", "views", params[:controller],"#{@game.title}.html.erb"))
      render "play/#{@game.title}"
    else
      render "play/show"
    end
  end

  def game
    flash.keep
    @handler=EventHandler.new(user: current_user, game: @game, task: @task)
    if !@handler.game_started?
      @start_time=@game.children.where(_type: "GameStarted").first.time
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
    @handler=EventHandler.new(user: current_user, game: @game, task: @task)
    CriticalSection.synchronize @game.id do
      @fired_events=@handler.input(params[:input]).to_a
      set_flash
    end
  end

  def back
    tgs=@game.descendant_events_of(type: "TaskGiven", user: current_user)
    ltg=tgs.sort { |tg1,tg2| tg1.time<=>tg2.time }.last
    events=@game.descendant_events.where(user: current_user).where(time: { "$gt"=> ltg.time })
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
    else
      flash[:alert]=t("play.alert.no_events")
      redirect_to play_show_url(game_id: @game.id, task_id: @task.id)
    end
  end
end
