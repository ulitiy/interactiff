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
end
