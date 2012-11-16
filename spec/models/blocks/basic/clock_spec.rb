require 'spec_helper'

describe Clock do
  let(:clock) { create :clock, time: Time.now }
  context "execution" do
    subject { clock.is_hit_by_any? }
    it { should be_true }
  end

  context "time change" do
    before { Delayed::Worker.delay_jobs=true; clock.time=2.seconds.from_now; clock.save; }
    subject { Delayed::Job.count }
    it { should eq(1) }
    after { Delayed::Worker.delay_jobs=false }
  end
end