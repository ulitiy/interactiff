class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    omniauth = request.env["omniauth.auth"]  
    account = Account.where(provider: omniauth['provider'], uid: omniauth['uid']).first
    if account  
      # The user have already used this external account
      flash[:notice] = 'Successfuly authenticated'
      account.user.remember_me = true
      sign_in_and_redirect(:user, account.user)
    elsif user_signed_in?
      # Add account to signed in user
      current_user.accounts.create!(provider: omniauth['provider'], uid: omniauth['uid'])
      redirect_to games_url, notice: "#{omniauth['provider']} successfuly added to your account"
    elsif user = create_new_omniauth_user(omniauth)
      # Register the new user + create new account
      user.accounts.create!(provider:  omniauth['provider'], uid:  omniauth['uid'])
      flash[:notice] = 'Welcome to interactiff'
      user.remember_me = true
      sign_in_and_redirect(:user, user)
    end  
  end
  def create_new_omniauth_user(omniauth)
    if omniauth['user_info']['email'].present?
      user = User.find_by_email(omniauth['user_info']['email'])
    end
    mail = (omniauth['user_info']['email'].present?) ? omniauth['user_info']['email'] : "#{omniauth['uid']}@interactiff.net"
    user ||= User.create! email: mail
    user
  end
  alias_method :facebook, :all
  alias_method :vkontakte, :all
  alias_method :google_oauth2, :all
end
