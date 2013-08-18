class SessionToken
  include Mongoid::Document
  embedded_in :user, class_name: "Guest"
  field :value, type: String

  def generate
    self.value=('a'..'z').to_a.shuffle[0,8].join
  end
end
