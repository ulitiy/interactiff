require 'spec_helper'

describe Setter do
  let(:team) { create :team }
  let(:user) { create :user, team: team }
  let(:game) { create :game }
  let(:var1) { create :variable, name: "var1", game: game }
  let(:var2) { create :variable, name: "var2", game: game }
  let(:var22) { create :variable, name: "var22", game: game }
  let(:setter) { Setter.create expression: "var1=Math.sqrt(var1)+var2*var22", parent: game }
  before { var1;var2;var22 }

  describe "#set_variable" do
    subject { setter.variable }
    it { should eq(var1) }
    it "checks get vars"
    it "checks replace vars"
  end

  describe "complex behavior" do
    before do
      Event.create scope: "for_one", user: user, time: Time.now, variable: var1, var_value: 25, block: setter
      Event.create scope: "for_team", team: team, time: Time.now, variable: var2, var_value: 10, block: setter
      Event.create scope: "for_all", time: Time.now, variable: var22, var_value: 30, block: setter
      setter.hit user: user, time: Time.now+1
    end
    subject { var1.value user: user, game: game }
    it { should eq(305) }
  end

  describe "#blocks_to_hit" do
    let!(:checker1) { Checker.create expression: "var1>var2", parent: game }
    let!(:checker2) { Checker.create expression: "var22>Math.sqrt(var1)", parent: game }
    let!(:checker3) { Checker.create expression: "var22>var2", parent: game }
    subject { setter.blocks_to_hit }
    it { should eq([checker1,checker2]) }
  end
end
