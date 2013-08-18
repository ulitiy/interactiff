# Admin constructor no-responsibility controller
class AdminController < ApplicationController
  layout "admin"
#ПЕРЕНЕСТИ ЭТОТ КОНТРОЛЛЕР В GAMES!!!
  def index
    @parent=Block.find params[:parent_id]
    @game=@parent.parent_game
    @select_id=params[:select_id]
    authorize! :show, @game
  end
end
