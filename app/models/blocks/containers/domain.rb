class Domain < Block
  field :name, type: String, :null => false, :default => ""
  attr_accessible :name, :main_host_id, :main_host
  belongs_to :main_host, class_name: "Host"
end
