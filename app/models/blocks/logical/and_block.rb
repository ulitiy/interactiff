class AndBlock < Block
  #if we find just one not-hit block
  def hot? options
    !in_blocks.find { |block| !block.is_hit?(options) }
  end
end
