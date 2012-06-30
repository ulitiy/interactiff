class RolesController < InheritedResources::Base
  respond_to :json
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource
end