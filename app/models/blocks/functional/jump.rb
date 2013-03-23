class Jump < Block
  attr_accessible :checkpoint_id, :checkpoint
  belongs_to :checkpoint, index: true

  def blocks_to_hit
    [checkpoint].compact
  end
end
