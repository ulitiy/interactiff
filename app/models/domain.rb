class Domain < Block
  acts_as_citier

  has_many :hosts, :dependent=>:destroy
  has_many :games, :dependent=>:destroy
  belongs_to :main_host, :class_name=>"Host", :foreign_key=>:main_host_id

  attr_accessible :name, :main_host_id, :hosts_attributes #for nested forms
  accepts_nested_attributes_for :hosts, :allow_destroy=>true

  validates_presence_of :name
  validates_uniqueness_of :name
end
