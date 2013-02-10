require 'spec_helper'

describe Game do
  describe "#authors" do
    let(:game1) { create :game }
    let(:game2) { create :game }
    let(:user1) { create :user }
    let(:user2) { create :user }
    let(:user3) { create :user }
    before do
      user1.engine_roles.create block: game1, access: :manage_roles
      user1.engine_roles.create block: game2, access: :manage
      user2.engine_roles.create block: game1, access: :manage
      user3.engine_roles.create block: game2, access: :manage
    end
    subject { game1.authors }
    it { should eq [user1,user2] }
  end
end
