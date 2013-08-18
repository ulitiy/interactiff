class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    omniauth = request.env["omniauth.auth"]
    user = User.where("accounts.provider" => omniauth[:provider], "accounts.uid" => omniauth[:uid]).first
    if user
      # The user have already used this external account
      flash[:notice] = 'Successfuly authenticated'
      user.remember_me = true
      sign_in_and_redirect user
    elsif user_signed_in?# && !current_user.is_a?(Guest)
      # Add account to signed in user
      current_user.accounts.create!(omniauth.slice(:provider, :uid))
      redirect_to games_url, notice: "#{omniauth[:provider]} successfuly added to your account"
    elsif user = create_or_get_user(omniauth)
      user.accounts.create!(omniauth.slice(:provider, :uid))
      if user.persisted?
        flash[:notice] = 'Welcome to interactiff'
        user.remember_me = true
        sign_in_and_redirect user
      else
        flash[:alert] = "Fail auth"
        redirect_to new_user_registration_url
      end
    else
      # New user data not valid, try again
      flash[:alert] = "Fail auth"
      redirect_to new_user_registration_url
    end
  end
  def create_or_get_user(omniauth)
    user_info = omniauth['info']
    if omniauth['extra'].present? && omniauth['extra']['raw_info'].present?
      user_info.merge!(omniauth['extra']['raw_info'])
    end
    mail = (user_info['email'].present?) ? user_info['email'] : "#{omniauth[:provider]}_#{omniauth[:uid]}@interactiff.net"
    user = User.where(email: mail).first || User.new
    if user.new_record?
      user.email = mail
      user.skip_confirmation!
      user.save(validate: false)
      logging_in
    else
      if !user.confirmed?
        user.encrypted_password = ''
        user.skip_confirmation!
        user.save(validate: false)
      end
    end
    user
  end
  alias_method :facebook, :all
  alias_method :vkontakte, :all
  alias_method :google_oauth2, :all
end
