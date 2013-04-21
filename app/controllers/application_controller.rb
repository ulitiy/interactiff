class ApplicationController < ActionController::Base

  protect_from_forgery
  # check_authorization :unless => :devise_controller?

  # @return [Domain] domain-parent of requested host
  def current_domain
    @current_domain||=current_host.parent if current_host
  end

  # @return [Host] requested host
  def current_host
    @current_host||=Host.where(:name=>request.host).first
  end

  before_filter :check_current_domain

  # Checks if current host is main_host of Domain, redirect otherwise
  # first domain should have main_host
  def check_current_domain
    cd=current_domain
    redirect_to [request.protocol,Domain.first.main_host.name,request.port_string].join, :status=>:moved_permanently and return false if cd.nil? #на главный домен
    redirect_to [request.protocol,cd.main_host.name,request.port_string,request.fullpath].join, :status=>:moved_permanently unless(cd.main_host_id==current_host.id || cd.main_host_id.nil?) #на главный хост
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
    request.session_options[:expire_after] = 1.month
    g=User.where(id: session[:guest_user_id]).first
    if g.nil?
      g=create_guest_user
      session[:guest_user_id]=g.id
    end
    g
  end

  private

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  # TODO: TEST ME, update_attributes
  def logging_in
    guest_user.events.each do |event|
      event.user_id=current_user_without_guest.id
      event.save
    end
  end

  def create_guest_user
    u = Guest.create(:email => "guest_#{Time.now.to_i}#{rand(99)}@example.com")
    u.save(:validate => false)
    u
  end

  def current_user_without_guest
    @current_user ||= warden.authenticate(:scope => :user)
  end

  def current_user_with_guest
    if current_user_without_guest
      if session[:guest_user_id]
        logging_in
        guest_user.destroy
        session[:guest_user_id] = nil
      end
      current_user_without_guest
    else
      guest_user
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in? && !current_user.is_a?(Guest)
      flash[:notice] = t("cancan.exceptions.denied")
      redirect_to root_url
    else
      authenticate_user!
    end
  end


  def refinery_user_required?
    false
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
