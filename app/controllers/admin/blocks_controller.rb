class Admin::BlocksController < ApplicationController
  layout "admin"

  def index
    #expires_in 1.hour
    #fresh_when etag: 0, public: true
  end
end
