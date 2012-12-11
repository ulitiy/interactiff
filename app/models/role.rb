class Role
  include Mongoid::Document

  belongs_to :user, index: true
  belongs_to :block, index: true

  index user_id: 1, block_id: 1

  field :access, type: Symbol

end
