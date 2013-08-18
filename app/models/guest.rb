# Guest user for anonymous access with linking
class Guest < User
  embeds_one :session_token, autobuild: true
  index "session_token.value" => 1
  before_save -> { session_token.generate }

  def token
    session_token.value
  end

  def self.get_by_token value
    Guest.where("session_token.value" => value).first if value.present?
  end
end
