class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    omniauth = request.env["omniauth.auth"]  
    user = User.where("accounts.provider" => omniauth[:provider], "accounts.uid" => omniauth[:uid]).first
    if user 
      # The user have already used this external account
      flash[:notice] = 'Successfuly authenticated'
      user.remember_me = true
      sign_in_and_redirect user
    elsif user_signed_in?
      # Add account to signed in user
      current_user.accounts.create!(omniauth.slice(:provider, :uid))
      redirect_to games_url, notice: "#{omniauth[:provider]} successfuly added to your account"
    elsif user = create_or_get_user(omniauth)
      # Register the new user + create new account
      flash[:notice] = 'Welcome to interactiff'
      user.remember_me = true
      sign_in_and_redirect user
    end  
  end
  def create_or_get_user(omniauth)
    mail = (omniauth[:user_info].present? && omniauth[:user_info][:email].present?) ? omniauth[:user_info][:email] : "#{omniauth[:provider]}_#{omniauth[:uid]}@interactiff.net"
    user = User.where(email: mail).first || User.new
    if user.new_record?
      user.email = mail
      account = user.accounts.where(omniauth.slice(:provider, :uid)).first || user.accounts.new
      if account.new_record?
        account.uid = omniauth[:uid]
        account.provider = omniauth[:provider]
      end
      user.save(validate: false)
    else
      account = user.accounts.where(omniauth.slice(:provider, :uid)).first || user.accounts.new
      if account.new_record?
        account.uid = omniauth[:uid]
        account.provider = omniauth[:provider]
        account.save!
      end
    end
    user
  end
  alias_method :facebook, :all
  alias_method :vkontakte, :all
  alias_method :google_oauth2, :all
end
