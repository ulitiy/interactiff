require 'spec_helper'

describe Block do
  let(:game) { create :game }
  let(:or_block) { create :or_block, parent: game }
  let(:or_block2) { create :or_block, parent: game }
  let(:or_block3) { create :or_block, parent: game }
  let(:and_block) { create :and_block, parent: game }
  let(:rel) { create :relation, from: or_block, to: and_block }
  let(:rel2) { create :relation, from: or_block2, to: and_block }
  let(:rel3) { create :relation, from: or_block3, to: and_block }
  let(:user) { create :user }
  let(:handler) { EventHandler.new(user: user,game:game) }

  before do
    rel;rel2;rel3
    handler.hit or_block
    handler.hit or_block2
  end

  describe "integrational behaviour" do
    it { and_block.is_hit?(handler.options).should be_false }
    it { handler.hit(or_block3); and_block.is_hit?(handler.options).should be_true}
  end

end
