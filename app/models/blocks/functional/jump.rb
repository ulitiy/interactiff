class Jump < Block
  attr_accessible :checkpoint_id, :checkpoint
  belongs_to :checkpoint, class_name: "Block", inverse_of: nil, index: true

  def blocks_to_hit
    [checkpoint].compact
  end
end
