module IntegrationMacros
  def create_domain
    @current_domain=Factory(:domain, :name=>"integration test domain")
    Factory(:host, :name=>"requests.lvh.me",:domain=>@current_domain)
    Factory(:game, :name=>"macro game")
  end

  def destroy_domain
    @current_domain.destroy
  end

  def current_domain
    @current_domain
  end
end