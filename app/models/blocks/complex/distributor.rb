class Distributor < Block
  def blocks_to_hit
    [out_blocks.sample].compact
  end
end
