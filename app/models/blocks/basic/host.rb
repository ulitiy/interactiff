class Host < Block
  field :name, type: String

  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name
end
