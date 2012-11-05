class UsersController < InheritedResources::Base
  actions :index, :show
  load_and_authorize_resource

  def show
    @games=@user.games
    show!
  end
end