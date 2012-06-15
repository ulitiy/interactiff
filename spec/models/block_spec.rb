require 'spec_helper'

describe Block do
  let(:domain) { create :domain }
  let(:host) { create :host, parent: domain }
  let(:game) { create :game, parent: domain }
  let(:task) { create :task, parent: game }
  let(:answer) { create :answer, parent: task }
  let(:domain2) { create :domain }
  let(:game2) { create :game, parent: domain2 }
  let(:and_block) { create :and_block, parent: game }

  before { domain;host;game;task;answer;and_block;domain2;game2 }

  it "REWRITE SPECS in the best practices"

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

end
