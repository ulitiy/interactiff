describe EvalBlock do

  let!(:user) { create :user }
  let!(:game) { create :game }
  let!(:task) { create :task, parent: game }
  let!(:answer) { create :answer, parent: task }
  let!(:var1) { create :variable, name: "var1", game: game, default: 10 }
  let!(:var2) { create :variable, name: "var2", game: game }
  let!(:var22) { create :variable, name: "var22", game: game }
  let!(:handler) { EventHandler.new(user: user, game: game) }
  let!(:eb) { EvalBlock.create(parent: game) }

  describe "#var_list" do
    subject { eb.var_list "var1+var1*var2.var22.to_i" }
    it { should eq(["var1","var2"]) }
  end

  # describe "#replace_vars" do
  #   subject { eb.replace_vars "var1+var1*var2.var22" }
  #   it { should eq("@vars['var1']+@vars['var1']*@vars['var2'].var22") }
  # end

  describe "#def_vars" do
    subject { eb.def_vars %w[var1 var2] }
    before { eb.vars={var1: 5, var2: 'qwer'} }
    # it { should eq("        def self.var1\n          $SANDBOX_VARS[var1]\n        end\n        def self.var2\n          $SANDBOX_VARS[var2]\n        end\n") }
  end

  describe "#get_vars" do
    before do
      Event.create user: user, block: answer, scope: :for_all, input: "20", time: Time.now
      eb.get_vars "var1+last_answer.to_i", game: game, user: user, handler: handler
    end
    context "var1" do
      subject { eb.vars["var1"] }
      it { should eq(10) }
    end
    context "last_answer" do
      subject { eb.vars["last_answer"] }
      it { should eq("20") }
    end
  end

  describe "#calculate_value" do
    subject { eb.calculate_value("Math.sqrt(25)+var1", user: user, game: game) }
    it { should eq(15) }
    it { eb.calculate_value("var1;$SANDBOX_VARS",user: user, game: game).should eq({"var1" => 10}) }
  end

end
