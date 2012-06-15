class Role
  include Mongoid::Document

  embedded_in :user
  belongs_to :block, inverse_of: nil

  field :access, type: Symbol, null: false

end
