class ApplicationController < ActionController::Base

  protect_from_forgery
  # check_authorization :unless => :devise_controller?

  helper_method :current_host

  # @return [Domain] domain-parent of requested host
  def current_domain
    # @current_domain||=current_host.parent if current_host
    Domain.first
  end

  # @return [Host] requested host
  def current_host
    # @current_host||=Host.where(:name=>request.host).first
    Host.first
  end

  prepend_before_filter :check_current_domain

  # Checks if current host is main_host of Domain, redirect otherwise
  # first domain should have main_host
  def check_current_domain
    # cd=current_domain
    # redirect_to [request.protocol,Domain.first.main_host.name,request.port_string].join, :status=>:moved_permanently and return false if cd.nil? #на главный домен
    # redirect_to [request.protocol,cd.main_host.name,request.port_string,request.fullpath].join, :status=>:moved_permanently unless(cd.main_host_id==current_host.id || cd.main_host_id.nil?) #на главный хост
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def current_user
    @current_user ||= warden.authenticate(:scope => :user)
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user
    @guest_user||=User.where(id: session[:guest_user_id]).first
  end

  private

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  # TODO: TEST ME
  def logging_in u=nil
    if guest_user
      guest_user.events.each do |event|
        event.update_attribute :user_id, (current_user_without_guest || u).id
      end
      guest_user.destroy
      @guest_user=nil
      session[:guest_user_id] = nil
    end
  end

  def create_guest
    request.session_options[:expire_after] = 1.month
    u = Guest.create(:email => "guest_#{Time.now.to_i}#{rand(99)}@example.com")
    u.save(:validate => false)
    session[:guest_user_id]=u.id
    u
  end

  def current_user_without_guest
    @current_user ||= warden.authenticate(:scope => :user)
  end

  def current_user_with_guest
    current_user_or_guest || create_guest
  end

  def user_or_guest_signed_in?
    user_signed_in? || session[:guest_user_id]
  end

  def current_user_or_guest
    if current_user_without_guest
      logging_in
      current_user_without_guest
    else
      guest_user
    end
  end

  helper_method :current_user_or_guest

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      flash[:notice] = t("cancan.exceptions.denied")
      redirect_to root_url
    else
      authenticate_user!
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || games_path
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

end
