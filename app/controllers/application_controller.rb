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

  alias old_current_user current_user

  # if user is logged in, return current_user, else return guest_user
  def current_user
    if old_current_user
      if session[:guest_user_id]
        logging_in
        guest_user.destroy
        session[:guest_user_id] = nil
      end
      old_current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user
    request.session_options[:expire_after] = 1.month
    User.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_guest_user.id  : session[:guest_user_id])
  end

  private

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  # TODO: TEST ME, update_attributes
  def logging_in
    guest_user.events.each do |event|
      event.user_id=old_current_user.id
      event.save
    end
  end

  def create_guest_user
    u = Guest.create(:email => "guest_#{Time.now.to_i}#{rand(99)}@example.com")
    u.save(:validate => false)
    u
  end

  rescue_from CanCan::AccessDenied do |exception|
    if !current_user.is_a? Guest
      flash[:notice] = t("cancan.exceptions.denied")
      redirect_to root_url
    else
      authenticate_user!
    end
  end
end
