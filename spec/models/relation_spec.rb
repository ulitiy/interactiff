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

end
