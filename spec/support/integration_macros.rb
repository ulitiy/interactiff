module IntegrationMacros
  def create_domain
    @current_domain=create(:domain, :name=>"current domain")
    create(:host, :name=>"requests.lvh.me",:parent=>@current_domain)
  end

  def destroy_domain
    @current_domain.destroy
  end

  def current_domain
    @current_domain
  end

  def double_click el
    page.execute_script("$('#{el}').trigger('dblclick')")
  end

end