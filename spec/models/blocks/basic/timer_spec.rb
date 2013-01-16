require 'spec_helper'

describe Timer do
  let(:timer) { create :timer }
  let(:user) { create :user }
  before { timer.reload.hit user: user }
  context "execution" do
    subject { timer.is_hit? user: user }
    it { should be_true }
  end
  context "execution time" do
    subject { timer.events.first.time.subsec.to_f }
    it { should_not eq(0) }
  end
end