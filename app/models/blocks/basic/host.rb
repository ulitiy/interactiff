class Host < Block
  acts_as_citier

  attr_accessible :name, :domain_id

  validates_presence_of :name
  validates_uniqueness_of :name
end
