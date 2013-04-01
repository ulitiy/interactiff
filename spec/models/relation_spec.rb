require 'spec_helper'

describe Relation do
  let(:relation) { create :relation }
  let(:game_relation) { create :game_relation }
  let(:game) { create :game }
  let(:game2) { create :game }

  describe "#as_json" do
    it "returns id field" do
      json=relation.as_json
      json["id"].should eq(relation._id)
    end
  end

  describe "#set_ids" do
    it "sets game_id for game relations" do
      rel=build :relation
      rel.from.game=game
      rel.to.game=game
      rel.save
      rel.game.should eq(game)
    end

    it "doesn't set game_id for out-game relations" do
      rel=build :relation
      rel.from.game=game
      rel.to.game=game2
      rel.save
      rel.game.should eq(nil)
    end
  end

  describe "relations_collection" do
    it "eeeh?"
  end

  describe "#backtrack" do
    let(:block1) { create :block, scope: "for_all" }
    let(:block2) { create :block }
    before { block1.hit }
    it("should create event") { expect { Relation.create from:block1, to:block2 }.to change { Event.count }.by(1) }
    it("should set all correct fields")
    describe "after" do
      before { Relation.create from:block1, to:block2 }
      it("should set correct scope") { block2.events.last.scope.should eq("for_all") }
    end
  end

end
