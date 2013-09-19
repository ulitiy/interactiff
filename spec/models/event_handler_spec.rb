require 'spec_helper'

describe EventHandler do
  let(:user) { create :user }
  let(:game) do
    Game.skip_callback(:validation, :before, :new_game)
    Game.skip_callback(:create, :after, :start)
    create :game
  end
  let(:task) { create :task, parent: game, input_type: "text" }
  let!(:answer) { create :answer, parent: task, body: "he(l)*o" }
  let!(:answer2) { create :answer, parent: task, body: ".*" }
  let!(:answer3) { create :answer, parent: task, body: "ehlo" }
  let(:tg) { create :task_given, parent: task }
  let(:tp) { create :task_passed, parent: task }
  let(:handler) { EventHandler.new(user: user,task: task) }
  let(:task1) { create :task, parent: game, input_type: "text" }
  let(:tg1) { create :task_given, parent: task1 }
  let(:tp1) { create :task_passed, parent: task1 }
  let(:task2) { create :task, parent: game, input_type: "text" }
  let(:tg2) { create :task_given, parent: task2 }
  let(:tp2) { create :task_passed, parent: task2 }
  let(:task3) { create :task, parent: game, input_type: "text" }
  let(:tg3) { create :task_given, parent: task3 }
  let(:task4) { create :task, parent: game, input_type: "text" }
  let(:tg4) { create :task_given, parent: task4 }
  let(:team1) { create :team }
  let(:team2) { create :team }
  let(:user1) { create :user, team: team1 }
  let(:user12) { create :user, team: team1 }
  let(:user2) { create :user, team: team2 }

  describe "#task_answers" do
    it { handler.task_answers.to_a.should eq([answer,answer2,answer3]) }
  end

  describe "#input" do
    context "task given" do
      before { tg.hit user: user, scope: "for_all" }
      before { handler.input "Hellllo, world!" }
      it("should fire the right answer") { handler.is_hit?(answer).should be_true }
      it("shouldn't fire the second answer") { handler.is_hit?(answer2).should be_false }
      it("shouldn't fire the wrong answer") { handler.is_hit?(answer3).should be_false }
      it("should set input") { answer.events.first.input.should eq("Hellllo, world!") }
    end
    context "task not given" do
      before { handler.input "Hellllo, world!" }
      it("should not fire the right answer") { handler.is_hit?(answer).should be_false }
    end
    context "task passed" do
      before { tp.hit user: user, scope: "for_all" }
      before { handler.input "Hellllo, world!" }
      it("should not fire the right answer") { handler.is_hit?(answer).should be_false }
    end
  end

  describe "#tasks_given" do
    subject { handler.tasks_given }
    before { tg1.hit(user: user1, scope: "for_one");tg2.hit(user:user1, team: team1,scope: "for_team");tg3.hit(user:user1,scope: "for_all");tg4 }
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

  describe "#current_tasks" do
    subject { handler.current_tasks }
    before do
      tg1.hit user: user
      tg2.hit user: user
      tp1.hit user: user
      tp2.hit user: user
      tg2.hit user: user
    end
    it { should eq([task2]) }
  end

  describe "#last_answer" do
    before do
      Event.create user: user, block: answer, scope: "for_one", input: "hello2", time: Time.now
      Event.create user: user, block: answer, scope: "for_one", input: "hello1", time: Time.now-1
    end
    subject { handler.last_answer }
    it { should eq("hello2") }
  end

  describe "#play_tasks" do
    it "test me"
  end

end
