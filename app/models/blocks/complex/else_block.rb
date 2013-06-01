class ElseBlock < Block

  def hot? options
    options[:parent].children.block_type("Condition").count==0
  end

end
