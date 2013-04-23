# Admin constructor no-responsibility controller
class Admin::BlocksController < ApplicationController
  layout "admin"

  def index
    @parent=Block.find params[:parent_id]
    authorize! :show, @parent.parent_game
  end
end
