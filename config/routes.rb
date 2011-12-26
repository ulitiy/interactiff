Joygen::Application.routes.draw do
  bulk_routes "/api/bulk"
  mount Bulk::Sproutcore.new => "/_sproutcore"

  root :to => "games#index"
end
