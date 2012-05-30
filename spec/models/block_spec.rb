require 'spec_helper'

describe Block do
  let(:domain) { FactoryGirl.create :domain }
  let(:host) { FactoryGirl.create :host, parent: domain }
  let(:game) { FactoryGirl.create :game, parent: domain }
  let(:task) { FactoryGirl.create :task, parent: game }
  let(:answer) { FactoryGirl.create :answer, parent: task }
  let(:domain2) { FactoryGirl.create :domain }
  let(:game2) { FactoryGirl.create :game, parent: domain2 }

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
  end

  describe "#parent_game" do
    it "returns self if it's game" do
      game.parent_game.should eq(game)
    end

    it "returns parent game if it's grandchild" do
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
    it "returns all parents" do
      game2
      answer.path.should eq([domain,game,task,answer])
    end
  end

  describe "#descendants" do
    it "returns all children and grandchildren" do
      task;answer
      and_block=AndBlock.create parent: game
      game.descendants.should eq([task,answer,and_block])
    end
  end

  describe "master_collection" do
    it "should return all domains for 0" do
      domain;game;task;domain2;game2
      Block.master_collection("0").should eq([domain,domain2])
    end

    it "should return domain + children for domain id" do
      task;game2
      Block.master_collection(domain.id.to_s).should eq([domain,game])
    end

    it "should return game children and path for game id" do
      answer;game2
      Block.master_collection(game.id.to_s).should eq([domain,game,task,answer])
    end

    it "should return game children and path for game grandchild id" do
      answer;domain2;game2
      Block.master_collection(task.id.to_s).should eq([domain,game,task,answer])
    end
  end

end
