class Domain < Block
  field :name, type: String
  attr_accessible :name, :main_host_id, :main_host
  belongs_to :main_host, class_name: "Host"
end
