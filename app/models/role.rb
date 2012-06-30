class Role
  include Mongoid::Document

  embedded_in :user
  belongs_to :block, inverse_of: nil, index: true

  field :access, type: Symbol

end
