class RelationsController < InheritedResources::Base
  respond_to :json
  skip_before_filter :verify_authenticity_token #отключаем защиту от CSRF, т.к. API
end