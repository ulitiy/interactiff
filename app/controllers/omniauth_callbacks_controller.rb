class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    omniauth = request.env["omniauth.auth"]  
    user = User.where("accounts.provider" => omniauth[:provider], "accounts.uid" => omniauth[:uid]).first
    if user 
      # The user have already used this external account
      flash[:notice] = 'Successfuly authenticated'
      user.remember_me = true
      sign_in_and_redirect user
    elsif user_signed_in? && !user.is_a? Guest
      # Add account to signed in user
      current_user.accounts.create!(omniauth.slice(:provider, :uid))
      redirect_to games_url, notice: "#{omniauth[:provider]} successfuly added to your account"
    elsif user = create_or_get_user(omniauth)
      if user.persisted?
        user.accounts.create!(omniauth.slice(:provider, :uid))
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
    user_info = omniauth['user_info']
    if omniauth['extra'].present? && omniauth['extra']['user_hash'].present?
      user_info.merge!(omniauth['extra']['user_hash'])
    end
    user = User.where(email: user_info['email']).first || User.new
    if user.new_record?
      user.email = (user_info['email'].present?) ? user_info['email'] : "#{omniauth[:provider]}_#{omniauth[:uid]}@interactiff.net"
      user.save(validate: false)
      logging_in
    end
    user
  end
  alias_method :facebook, :all
  alias_method :vkontakte, :all
  alias_method :google_oauth2, :all
end
