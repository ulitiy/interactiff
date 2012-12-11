describe Hint do
  describe "#body_with_vars" do
    let(:user) { create :user }
    let(:game) { create :game }
    let(:hint) { create :hint, body: "asdf {{var1+var2}} qwer", parent: game }
    let(:handler) { EventHandler.new(user: user, game: game) }
    let(:var1) { create :variable, name: "var1", game: game, default: 10 }
    let(:var2) { create :variable, name: "var2", game: game, default: 5 }
    before { var1;var2 }
    it { Variable.where(game: game, name: "var1").first.should eq(var1) }
    subject { hint.body_with_vars game: game, user: user, handler: handler }
    it { should eq("asdf 15 qwer") }
  end
end
