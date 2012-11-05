class Admin::BlocksController < ApplicationController
  layout "admin"
  before_filter :authenticate_user!

  def index
    #expires_in 1.hour
    #fresh_when etag: 0, public: true #change etag on version change
  end
end
