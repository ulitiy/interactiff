class ApplicationController < ActionController::Base

  protect_from_forgery

  def current_domain
    @current_domain||=current_host.parent if current_host
  end

  def current_host
    @current_host||=Block::Host.first(:conditions=>{:name=>request.host})
  end

  before_filter :check_current_domain #сразу же проверяем, является ли данный хост основным, иначе - сразу перенаправляем

  def check_current_domain
    cd=current_domain
    #У ПЕРВОГО ДОМЕНА ОБЯЗАН БЫТЬ main_host
    redirect_to [request.protocol,Domain.first.main_host.name,request.port_string].join, :status=>:moved_permanently and return false if cd.nil? #на главный домен
    redirect_to [request.protocol,cd.main_host.name,request.port_string,request.fullpath].join, :status=>:moved_permanently unless(cd.main_host_id==current_host.id || cd.main_host_id.nil?) #на главный хост
  end
end
