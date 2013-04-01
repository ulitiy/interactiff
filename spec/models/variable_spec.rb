describe Variable do
  let(:team) { create :team }
  let(:user) { create :user, team: team }
  let(:game) { create :game }
  let(:setter) { create :setter, parent: game }
  let(:var1) { create :variable, name: "var1", game: game }
  describe "#value" do
    subject { var1.value({user: user}) }
    context "default" do
      it { should eq(0) }
    end
    context "with events" do
      before do
        Event.create scope: "for_team", team: team, time: Time.now+1, variable: var1, var_value: 20, block: setter
        Event.create scope: "for_one", user: user, time: Time.now, variable: var1, var_value: 15, block: setter
      end
      it { should eq(20) }
    end
  end
end
