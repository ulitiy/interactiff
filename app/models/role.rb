class Role
  include Mongoid::Document

  belongs_to :user, index: true
  belongs_to :block, index: true

  field :access, type: Symbol

end
