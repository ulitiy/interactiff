require 'spec_helper'

describe EventHandler do
  let(:user) { create :user }
  let(:game) { create :game }
  let(:task) { create :task, parent: game }
  let(:answer) { create :answer, parent: task, body: "he(l)*o", y: 10 }
  let(:answer2) { create :answer, parent: task, body: ".*", y: 20 }
  let(:answer3) { create :answer, parent: task, body: "ehlo", y: 15 }
  let(:tg) { create :task_given, parent: task }
  let(:handler) { EventHandler.new(user: user,task: task) }
  let(:task1) { create :task, parent: game }
  let(:tg1) { create :task_given, parent: task1 }
  let(:task2) { create :task, parent: game }
  let(:tg2) { create :task_given, parent: task2 }
  let(:task3) { create :task, parent: game }
  let(:tg3) { create :task_given, parent: task3 }
  let(:task4) { create :task, parent: game }
  let(:tg4) { create :task_given, parent: task4 }
  let(:team1) { create :team }
  let(:team2) { create :team }
  let(:user1) { create :user, team: team1 }
  let(:user12) { create :user, team: team1 }
  let(:user2) { create :user, team: team2 }

  describe "#task_answers" do
    before { answer3;answer2;answer }
    it { handler.task_answers.to_a.should eq([answer,answer3,answer2]) }
  end

  describe "#input" do
    before { tg.hit user: user, scope: :for_all; }
    before { answer3;answer2;answer;handler.input "Hellllo, world!";}
    context "task given" do
      it("should hit the right answer") { handler.is_hit?(answer).should be_true }
      it("shouldn't hit the second answer") { handler.is_hit?(answer2).should be_false }
      it("shouldn't hit the wrong answer") { handler.is_hit?(answer3).should be_false }
      it("should set input") { answer.events.first.input.should eq("Hellllo, world!") }
    end
  end

  describe "#tasks_given" do
    subject { handler.tasks_given }
    before { tg1.hit(user: user1, scope: :for_one);tg2.hit(user:user1, team: team1,scope: :for_team);tg3.hit(user:user1,scope: :for_all);tg4 }
    context "for user1" do
      let(:handler) { EventHandler.new(user: user1,game: game) }
      it { should eq([task1,task2,task3]) }
    end
    context "for user12" do
      let(:handler) { EventHandler.new(user: user12,game: game) }
      it { should eq([task2,task3]) }
    end
    context "for user2" do
      let(:handler) { EventHandler.new(user: user2,game: game) }
      it { should eq([task3]) }
    end
  end

  describe "#play_tasks" do
    it "test me"
  end
end
