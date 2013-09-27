# Guest user for anonymous access with linking
class Guest < User
  embeds_one :session_token, autobuild: true
  index "session_token.value" => 1
  before_save -> { session_token.generate }
  before_create -> { self.confirmed_at=Time.now }

  def token
    session_token.value
  end

  def self.get_by_token value
    Guest.where("session_token.value" => value).first if value.present? #проверка=перестраховка
  end

  def self.get_or_create_by_token value
    Guest.where("session_token.value" => value).first || Guest.create(:validate => false) if value.present?
  end

end
