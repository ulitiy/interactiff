class Account
  include Mongoid::Document
  field :provider, type: String
  field :uid, type: String
  index provider: 1, uid: 1
  embedded_in :user
end