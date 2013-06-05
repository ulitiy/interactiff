class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    omniauth = request.env["omniauth.auth"]  
    account = Account.where(:provider => omniauth['provider'], :uid => omniauth['uid']).first
    if account  
      # Just sign in an existing user with omniauth
      # The user have already used this external account
      flash.notice = 'Successfuly authenticated'
      sign_in_and_redirect(:user, account.user)
    elsif current_user
      # Add account to signed in user
      # User is logged in
      current_user.accounts.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      redirect_to games_url, notice: "#{omniauth['provider']} successfuly added to your account"
    elsif user = create_new_omniauth_user(omniauth)
      # Create a new User through omniauth
      # Register the new user + create new account
      user.accounts.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = 'Welcome'
      sign_in_and_redirect(:user, user)
    else
      # New user data not valid, try again
      flash[:alert] = 'Fail auth'
      redirect_to new_user_registration_url
    end  
  end
  def create_new_omniauth_user(omniauth)
    if omniauth['user_info']['email'].present?
      user = User.find_by_email(omniauth['user_info']['email'])
    end
    user ||= User.new
    if user.new_record?
      user.email = (omniauth['user_info']['email'].present?) ? omniauth['user_info']['email'] : "#{omniauth['uid']}@interactiff.net"
      if user.save
        user
      else
        nil
      end
    else
      user
    end
  end
  alias_method :facebook, :all
  alias_method :vkontakte, :all
  alias_method :google_oauth2, :all
end
