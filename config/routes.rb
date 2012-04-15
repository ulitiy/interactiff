Joygen::Application.routes.draw do
  resources :blocks, except: [:index,:new]
  resources :domains, :games, :tasks,
    :answers, :hints, :hosts, :timers, :clocks,
    :task_givens, :task_passeds, :game_starteds, :game_passeds, :inputs, :outputs,
    :not_blocks, :and_blocks, :or_blocks,
    :checkers, :setters, :distributors, :eval_blocks,
    :path=>"/blocks"
  resources :relations
  match "/admin/:postfix" => "Admin::Blocks#index", :constraints => { :postfix => /.*/ }
end
