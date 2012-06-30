class RelationsController < InheritedResources::Base
  actions :create, :destroy
  respond_to :json
  load_and_authorize_resource only: [:create, :destroy]
  skip_before_filter :verify_authenticity_token #отключаем защиту от CSRF, т.к. API
end