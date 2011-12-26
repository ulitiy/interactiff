module ControllerMacros

  def stub_check_current_domain
    controller.stub(:check_current_domain).and_return(true)
  end

  def stub_current_domain
    host=Factory(:host)
    domain=host.domain
    controller.stub(:current_host).and_return(host)
    controller.stub(:current_domain).and_return(domain)
    @current_domain=domain
  end

end