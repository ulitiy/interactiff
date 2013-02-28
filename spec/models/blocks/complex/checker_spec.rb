describe Checker do
  let(:team) { create :team }
  let(:user) { create :user, team: team }
  let(:game) { create :game }
  let(:task) { create :task, parent: game }
  # let!(:handler) { EventHandler.new(user: user, game: game, task: task) }
  let!(:var1) { create :variable, name: "var1", game: game, default: 100 }
  let!(:var2) { create :variable, name: "var2", game: game, default: 10 }
  let!(:var22) { create :variable, name: "var22", game: game, default: 5 }
  let!(:checker) { Checker.create expression: "var1>var2+15*var22", parent: game }
  let!(:checker2) { Checker.create expression: "var1>var2+15*var22", parent: game }
  let(:setter) { Setter.create parent: game }

  describe "#set_variables" do
    subject { checker.reload.variables }
    it { should eq([var1,var2,var22]) }
    it { var1.reload.checkers.should eq([checker,checker2]) } #!!!
    it { checker.destroy }
  end

  describe "#hot?" do
    subject { checker.hot? user: user, game: game }
    it { should be_true }
    context "when last_answer is set" do
      let!(:checker) { Checker.create expression: "var1==\"ans\"", parent: task }
      before { Event.create user: user, block: setter, variable: var1, var_value: "ans" }
      it { should be_true }
    end
  end
end
