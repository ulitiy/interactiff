require 'spec_helper'

describe "rooms" do
  let!(:user) { create :user }
  let!(:game) { create :game }
  let!(:task) { create :task, parent: game }
  let!(:task_given) { create :task_given, parent: task }
  let!(:task_passed) { create :task_passed, parent: task }
  let (:hint) { create :hint, parent: task }
  let (:options) do {scope: "for_one", game: game, task: task, user: user} end
  subject { task }
  context "on first visit" do
    before { task_given.fire options; task.load_rooms(options) }
    context "when task not passed" do
      its(:visit_count) { should eq(1) }
      its(:passed) { should be_false }
    end
    context "when task passed" do
      before { task_passed.fire(options); task.load_rooms(options) }
      its(:visit_count) { should eq(1) }
      its(:passed) { should be_true }
      context "with hint" do
        before { hint.fire(options) }
        it { hint.is_hit?(user: user).should be_true }
      end
    end
  end

  context "second visit" do
    before { task_given.fire(options); task.load_rooms(options) }
    context "without hint" do
      before do
        task_passed.fire(options)
        task_given.fire(options)
        task.load_rooms(options)
      end
      its(:visit_count) { should eq(2) }
      its(:passed) { should be_false }
    end
    context "with hint" do
      context "hit first time" do
        before { hint.fire(options)
          task_passed.fire(options)
          task_given.fire(options)
          task.load_rooms(options) }
        it { hint.is_hit?(user: user).should be_false }
      end
      context "hit second time" do
        before { task_passed.fire(options)
          task_given.fire(options)
          hint.fire(options)
          task.load_rooms(options) }
        it { hint.is_hit?(user: user).should be_true }
        it { hint.events.first.visit_count.should eq(2) }
      end
    end
  end

  #tasks given
  #tasks passed
  #hints given
end
