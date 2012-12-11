class Hint < Block
  field :body, type: String, :default => ""

  attr_accessible :body

  def body_with_vars options
    eb=EvalBlock.new
    body.gsub /{{.*?}}/ do |part|
      part=part.scan(/{{(.*?)}}/)[0][0]
      eb.calculate_value(part,options).to_s
    end
  end

end
