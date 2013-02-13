Interactiff::Application.routes.draw do
  match "/delayed_job" => DelayedJobWeb, :anchor => false

  devise_for :users
  root :to => 'refinery/pages#home'

  # root to: "games#index"
  resources :games, path: "/quests"
  resources :blocks#, except: [:index,:new]
  match "/blocks/:id/master" => "blocks#master"
  resources :relations
  match "/admin/:parent_id/:select_id" => "Admin::Blocks#index", as: :admin,
    :constraints => { parent_id: /0|[0-9a-f]{24}/,select_id: /0|[0-9a-f]{24}/ }, via: :get
  #здесь разные форматы format: :json
  match "/play/:game_id(/:task_id)" => "play#show", as: :play_show, :constraints => { game_id: /[0-9a-f]{24}/,task_id: /[0-9a-f]{24}/ }, via: [:get]
  match "/play/submit" => "play#submit", as: :play_submit, via: [:get, :post]
  mount Refinery::Core::Engine, :at => '/'
end
