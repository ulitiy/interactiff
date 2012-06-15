require 'spec_helper'
describe BlocksController do
  before(:each) { stub_check_current_domain }

  describe "POST create" do
    it "sets the correct type of the block" do
      sign_in create(:root_user)
      post :create, block: {type: "Domain"}
      assigns(:block).should be_a(Domain)
    end
  end
end
