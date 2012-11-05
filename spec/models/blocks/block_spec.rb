require 'spec_helper'

describe Block do
  let(:domain) { create :domain }
  let(:host) { create :host, parent: domain }
  let(:game) { create :game, parent: domain }
  let(:task) { create :task, parent: game }
  let(:answer) { create :answer, parent: task }
  let(:domain2) { create :domain }
  let(:game2) { create :game, parent: domain2 }
  let(:task2) { create :task, parent: game2 }
  let(:and_block) { create :and_block, parent: game }

  before { domain;host;game;task;answer;and_block;domain2;game2 }

  describe "#as_json" do
    it "returns type and id fields" do
      json=domain.as_json
      json["type"].should eq("Domain")
      json["id"].should eq(domain._id)
    end
  end

  describe "#type" do
    it "returns correct type" do
      domain.type.should eq("Domain")
      host.type.should eq("Host")
    end
  end

  describe "#set_ids" do

    it "sets game_id for a created child block" do
      task.game.should eq(game)
    end

    it "sets task_id for a created child block" do
      answer.task.should eq(task)
    end

    it "sets game_id for a created grandchild block" do
      answer.game.should eq(game)
    end

    it "sets game_id for a new grandchild block" do
      Answer.new(parent:task).game.should eq(game)
    end
  end

  describe "#parent_game" do
    it "returns self if it's game" do
      game.parent_game.should eq(game)
    end

    it "returns parent game if it's a grandchild" do
      answer.parent_game.should eq(game)
    end
  end

  describe "#parent_task" do
    it "returns self if it's task" do
      task.parent_task.should eq(task)
    end

    it "returns parent task if it's child" do
      answer.parent_task.should eq(task)
    end
  end

  describe "#path" do
    subject { answer.path }
    it { should eq([domain,game,task,answer]) }
  end

  describe "#descendants" do
    subject { game.descendants }
    it { should eq([task,answer,and_block]) }
  end

  describe "master_collection" do
    it("when 0 should return all domains") { Block.master_collection("0").should eq([domain,domain2]) }
    it("when domain id should return domain + children") { Block.master_collection(domain.id.to_s).should eq([domain,host,game]) }
    it("when game id should return game children and path") { Block.master_collection(game.id.to_s).should eq([domain,game,task,answer,and_block]) }
    it("when game grandchild id should return game children and path") { Block.master_collection(task.id.to_s).should eq([domain,game,task,answer,and_block]) }
  end






  let(:team1) { create :team }
  let(:user1) { create :user, team: team1, member_of_games: [game] }
  let(:user12) { create :user, team: team1, member_of_games: [game] }
  let(:team2) { create :team }
  let(:user2) { create :user, team: team2, member_of_games: [game] }
  let(:user) { user1 }
  let(:team) { team1 }

  describe "#is_hit?" do
    subject { block.is_hit? user: user }
    before do
      block.fire user: user1
    end
    context "when for_one" do
      let(:block) { create :block, parent: game, scope: :for_one }
      context "when correct user" do
        let(:user) { user1 }
        it { should eq(true) }
      end
      context "when incorrect user" do
        let(:user) { user12 }
        it { should eq(false) }
      end
    end
    context "when for_all" do
      let(:block) { create :block, parent: game, scope: :for_all }
      let(:user) { user2 }
      it { should eq(true) }
    end
    context "when for_team" do
      let(:block) { create :block, parent: game, scope: :for_team }
      context "when teammate" do
        let(:user) { user12 }
        it { should eq(true) }
      end
      context "when not teammate" do
        let(:user) { user2 }
        it { should eq(false) }
      end
    end
  end

  describe "#scope_users" do
    let(:block) { create :block, parent: game, scope: :for_one }
    before { [user1,user12,user2].each { |u| u.member_of_games<<game; }; game.reload }
    context "when for_all" do
      subject { block.scope_users scope: :for_all, user: user1 }
      it { should eq([user1,user12,user2])}
    end
    context "when for_team" do
      subject { block.scope_users scope: :for_team, user: user1 }
      it { should eq([user1,user12]) }
    end
  end

  describe "#get_scope" do
    subject { block.get_scope scope: :for_team }
    context "when for_one" do
      let(:block) { create :block, scope: :for_one}
      it { should eq(:for_team) }
    end
    context "when for_all" do
      let(:block) { create :block, scope: :for_all}
      it { should eq(:for_all) }
    end
  end

  describe "#fire" do
    context "common" do
      let(:block1) { create :block, parent: task }
        let(:block2) { create :block, parent: task }
        let(:block3) { create :block, parent: task }
          let(:block4) { create :block, parent: task2 }
          let(:block5) { create :block, parent: task2 }
      let(:block6) { create :block, parent: task2 }
      let(:hint) { create :hint, parent: task }
      before do
        create :relation, from: block1, to: block2
        create :relation, from: block1, to: block3
        create :relation, from: block3, to: block4
        create :relation, from: block3, to: block5
        block6
      end
      it("should create 5 events") { expect { block1.fire }.to change { Event.count }.by(5) }
      it("should fire itself") { block1.fire; block1.events.count.should eq(1) }
      it("should fire 'child effect' block") { block1.fire; block2.events.count.should eq(1) }
      it("should fire 'grandchild effect' block") { block1.fire; block4.events.count.should eq(1) }
      it("should not fire other blocks") { block1.fire; block6.events.count.should eq(0) }
      it("should set parent event") { block1.fire; block4.events.first.parent.block.should eq(block3) }
      it("should set source event") { block1.fire; block4.events.first.source.block.should eq(block1) }
      it("should set correct game") { block1.fire; block4.events.first.game.should eq(game2) }
      it("should set correct task") { block1.fire; block4.events.first.task.should eq(task2) }
      it("should set correct block_type") { hint.fire; hint.events.first.block_type.should eq("Hint") }
      it("should return correct array")
      # it("should set mutex on mutex: true") do
      #   Thread.new { block1.fire(mutex: true) }
      #   sleep 0.01
      #   c=CriticalSection.new game.id
      #   c.lock?.should be_true
      #   sleep 0.1
      #   c.lock?.should be_false
      # end
      # it("should not set mutex") { Thread.new { block1.fire }; CriticalSection.new(game.id).lock?.should be_false }
    end

    context "scope" do
      before do
        user1; user12; user2
        create :relation, from: block1, to: block2
      end
      context "for_team to not personal for_one" do
        let(:block1) { create :block, parent: game, scope: :for_team }
        let(:block2) { create :block, parent: game, scope: :for_one }
        before { block1.fire user: user }
        it { block2.events.count.should eq(1) } #because isn't personal
        it { block2.events.first.scope.should eq(:for_team) }
        it { block2.events.first.team.should eq(team) }
      end
      context "for_one to personal for_all" do
        let(:block1) { create :block, parent: game, scope: :for_one }
        let(:block2) { create :sms, parent: game, scope: :for_all }
        before do
          [user1,user12,user2].each { |u| u.member_of_games<<game; }
          game.reload
          block2.stub!(:personal).and_return(true)
          block1.fire(user: user)
        end

        it { block2.personal.should eq(true) }
        it { block2.events.count.should eq(3) }
        it { block2.events.first.scope.should eq(:for_one) }
        it { block2.events.last.user.should eq(user2) }
      end
    end
  end

end
