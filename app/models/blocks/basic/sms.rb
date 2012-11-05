class Sms < Block
  field :body, type: String, :default => ""
  attr_accessible :body
  def personal
    true
  end
end
