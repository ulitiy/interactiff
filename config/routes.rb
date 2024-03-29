Interactiff::Application.routes.draw do
  mount Locomotive::Engine => '/locomotive', as: 'locomotive' # you can change the value of the path, by default set to "/locomotive"

  filter :refinery_like_locales

  devise_for :users, :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "login" }, :controllers => {registrations: "registrations", omniauth_callbacks: "omniauth_callbacks"}

  resources :games, path: "/scripts" do
    member do
      post "reset"
      get "timeline"
      get "iframe"
      get "embed"
      post "clone"
    end
  end
  resources :relations
  match "/admin/:parent_id/:select_id" => "admin#index", as: :admin, :constraints => { parent_id: /0|[0-9a-f]{24}/,select_id: /0|[0-9a-f]{24}/ }, via: :get
  # здесь разные форматы format: :json
  get "/play/:game_id/:task_id" => "play#show", as: :play_show, :constraints => { game_id: /[0-9a-f]{24}/,task_id: /[0-9a-f]{24}/ }
  get "/play/:game_id" => "play#game", as: :play_game, :constraints => { game_id: /[0-9a-f]{24}/ }
  match "/play/submit" => "play#submit", as: :play_submit, via: [:get, :post]
  get "/play/back" => "play#back", as: :play_back

  resources :blocks, :domains, :games, :tasks,
    :answers, :hints, :messages, :timers, :clocks,
    :task_givens, :task_passeds, :game_starteds, :game_passeds, :checkpoints, :jumps,
    :and_blocks, :or_blocks,
    :conditions, :checkers, :setters, :else_blocks, :add_row_blocks,
    :distributors, :request_blocks, :redirect_blocks,
    :path=>"/blocks"
  match "/blocks/:id/master" => "blocks#master"

  match "/aeroflot" => redirect("/ru/play/512cbdf17423384b06000019?ust=embed")
end
