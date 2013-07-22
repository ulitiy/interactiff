# Admin constructor no-responsibility controller
class AdminController < ApplicationController
  layout "admin"

  def index
    @parent=Block.find params[:parent_id]
    @game=@parent.parent_game
    authorize! :show, @game
  end

  def timeline
    @parent=Block.find params[:parent_id]
    @game=@parent.parent_game
    authorize! :show, @game
  end
end
