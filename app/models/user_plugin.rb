class UserPlugin
  include Mongoid::Document
  belongs_to :user, index: true
  field :name, type: String
  field :position, type: Integer
  attr_accessible :user_id, :name, :position
end