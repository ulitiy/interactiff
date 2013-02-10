class RefineryRole
  include Mongoid::Document
  field :title, type: String
  has_and_belongs_to_many :users, index: true

  before_validation :camelize_title
  validates :title, :uniqueness => true

  def camelize_title(role_title = self.title)
    self.title = role_title.to_s.camelize
  end

  def self.[](title)
    find_or_create_by(title: title.to_s.camelize)
  end
end