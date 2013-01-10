require 'spec_helper'
require "cancan/matchers"

describe User do
  describe "abilities" do
    subject { ability }

    let(:ability) { Ability.new(user) }
    let(:domain) { create :domain }
    let(:host) { create :host, parent: domain }
    let(:game) { create :game, parent: domain }
    let(:task) { create :task, parent: game }
    let(:answer) { create :answer, parent: task }
    let(:hint) { create :hint, parent: task }
    let(:domain2) { create :domain }
    let(:game2) { create :game, parent: domain2 }
    let(:task2) { create :task, parent: game2 }
    let(:answer2) { create :answer, parent: task2 }
    let(:hint2) { create :hint, parent: task2 }

    context "when has no roles" do
      let(:user) { create :user }
      it { should_not be_able_to(:read, Block) }
      it { should_not be_able_to(:read, Role) }
      it { should_not be_able_to(:read, Relation) }
    end
    context "when is a root user" do
      let(:user) { create :root_user }
      it { should be_able_to(:manage, domain) }
      it { should be_able_to(:manage, domain2) }
      it { should be_able_to(:manage, answer) }
      it { should be_able_to(:manage, Relation.new(from:answer,to:hint)) }
      it { should be_able_to(:manage, Role.new(block:domain2)) }
      it { should be_able_to(:manage, Role.new(block:task)) }
    end
    context "when is a domain owner" do
      let(:user) { create :user_with_role, block: domain }
      it { should be_able_to(:manage, domain) }
      it { should_not be_able_to(:manage, domain2) }
      it { should be_able_to(:manage, Relation.new(from:answer,to:hint)) }
      it { should_not be_able_to(:manage, Relation.new(from:answer2,to:hint2)) }
      # it { should_not be_able_to(:create, Block) } #почему так??? ну вот так...
    end
    context "when is a game author" do
      let(:user) { create :user_with_role, block: game }
      it { should be_able_to(:manage, game) }
      it { should be_able_to(:manage, answer) }
      it { should be_able_to(:manage, Answer.new(parent: task)) }
      it { should_not be_able_to(:manage, game2) }
      it { should_not be_able_to(:manage, Answer.new(parent: task2)) }
    end
    context "when is a task author" do
      let(:user) { create :user_with_role, block: task }
      it { should be_able_to(:manage, task) }
      it { should be_able_to(:manage, hint) }
      it { should be_able_to(:manage, Answer.new(parent: task)) }
      it { should_not be_able_to(:manage, game2) }
      it { should_not be_able_to(:manage, task2) }
      it { should_not be_able_to(:manage, Task.new(parent: game)) }
    end

    context "when is :manage_roles" do
      let(:user) { create :user_with_role, block: domain }
      it { should be_able_to(:manage, Role.new(block: domain)) }
      it { should be_able_to(:manage, Role.new(block: task)) }
      it { should_not be_able_to(:manage, Role.new(block: domain2)) }
      it { should_not be_able_to(:manage, Role.new(block: game2)) }
    end

    context "when is :manage" do
      let(:user) { create :user_with_role, block: domain, access: :manage }
      it { should_not be_able_to(:manage, Role) } #а в контексте should_not такое допустимо
      it { should be_able_to(:manage, Relation.new(from:answer,to:hint)) }
    end

    context "when is read" do
      let(:user) { create :user_with_role, block: domain, access: :read }
      it { should be_able_to(:read, domain) }
      it { should_not be_able_to(:manage, Role) }
      it { should_not be_able_to(:manage, Block) }
      it { should_not be_able_to(:manage, Relation) }
    end

    context "membership" do
      context "when registered user" do
        let(:user) { create :user }
        it { should be_able_to(:join, game) }
      end
      context "when not registered user" do #impossible scenario, but let's try
        let(:user) { Guest.new }
        it { should_not be_able_to(:join, game) }
      end
    end

    context "play" do
      it "should authorise for play"
    end

    context "create game" do
      it "should authorise for create game"
    end

  end

  describe "#games" do
    let(:game1) { create :game }
    let(:game2) { create :game }
    let(:game3) { create :game }
    let(:user) { create :user }
    before do
      user.roles.create block: game1, access: :manage_roles
      user.roles.create block: game2, access: :manage
      user.roles.create block: game3, access: :read
    end
    subject { user.games }
    it { should eq [game1,game2] }
  end
end
