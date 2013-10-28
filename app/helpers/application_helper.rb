module ApplicationHelper

  def title str
    body_title str
    head_title str
  end

  def head_title str
    content_for :head_title, str
  end

  def body_title str
    content_for :body_title, str
  end

  def rlink
    controller.class.name=~/Locomotive/ ? locomotive : self
  end

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def current_page?(options)
    unless request
      raise "You cannot use helpers that need to determine the current "                  "page unless your view context provides a Request object "                  "in a #request method"
    end

    return false unless request.get? || request.head?

    url_string = url_for(options)

    # We ignore any extra parameters in the request_uri if the
    # submitted url doesn't have any either. This lets the function
    # work with things like ?order=asc
    request_uri = url_string.index("?") ? request.fullpath : request.path

    if url_string =~ /^\w+:\/\//
      url_string == "#{request.protocol}#{request.host_with_port}/#{I18n.locale}#{request_uri}"
    else
      url_string == "/#{I18n.locale}#{request_uri}"
    end
  end

  def locomotive_page_path path
    "#{I18n.locale}/#{path}"
  end

end
