class Checkpoint < Block
  field :name, type: String, :default => ""
  attr_accessible :name
  has_many :jumps
end
