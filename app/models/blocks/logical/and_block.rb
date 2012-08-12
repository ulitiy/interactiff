class AndBlock < Block
  def hot? options
    !in_blocks.find { |block| !block.is_hit?(options) }
  end
end
