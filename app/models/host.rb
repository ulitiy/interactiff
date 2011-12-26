class Host < ActiveRecord::Base
  acts_as_citier

  belongs_to :domain
  #has_one :main_domain, :class_name=>:host,

  attr_accessible :name, :domain_id

  validates_presence_of :name
  #validates_presence_of :domain #it breaks creation of domain+hosts
  validates_uniqueness_of :name
end
