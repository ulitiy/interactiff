class EvalBlock < Block
  # arr=[]; (1..1000000000).each do arr.push "long string long string" end
  # Executes unsafe ruby code in safe env
  def execute str
    begin
      @t=Thread.start do
        $SAFE=4
        eval str
      end
      @t.kill unless t.join(0.5)
      @t.value
    rescue Exception => e
      #TODO: log exception here
    end
  end

  attr_accessor :t
end
