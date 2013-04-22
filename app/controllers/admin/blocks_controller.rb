# Admin constructor no-responsibility controller
class Admin::BlocksController < ApplicationController
  layout "admin"

  def index
    @parent=Block.find params[:parent_id]
    authorize! :read, @parent
    #expires_in 1.hour
    #fresh_when etag: 0, public: true #change etag on version change
  end
end
