Joygen::Application.routes.draw do
  resources :blocks, except: [:index,:new]
  resources :domains, :games, :tasks,
    :answers, :hints, :hosts, :timers, :clocks,
    :task_givens, :task_passeds, :game_starteds, :game_passeds, :inputs, :outputs,
    :not_blocks, :and_blocks, :or_blocks,
    :checkers, :setters, :distributors, :eval_blocks,
    :path=>"/blocks"
  resources :relations
  match "/admin/:parent_id/:select_id" => "Admin::Blocks#index", :constraints => { parent_id: /0|[0-9a-f]{24}*/,select_id: /0|[0-9a-f]{24}*/ }, as: :admin
end
