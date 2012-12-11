describe Checker do
  let(:team) { create :team }
  let(:user) { create :user, team: team }
  let(:game) { create :game }
  let(:var1) { create :variable, name: "var1", game: game, default: 100 }
  let(:var2) { create :variable, name: "var2", game: game, default: 10 }
  let(:var22) { create :variable, name: "var22", game: game, default: 5 }
  let(:checker) { Checker.create expression: "var1>var2+15*var22", parent: game }
  let(:checker2) { Checker.create expression: "var1>var2+15*var22", parent: game }
  let(:setter) { Setter.create parent: game }

  describe "#set_variables" do
    before { var1;var2;var22;checker;checker2 }
    subject { checker.reload.variables }
    it { should eq([var1,var2,var22]) }
    it { var1.reload.checkers.should eq([checker,checker2]) } #!!!
  end

  describe "#hot?" do
    before { var1;var2;var22 }
    subject { checker.hot? user: user, game: game }
    it { should be_true }
  end
end