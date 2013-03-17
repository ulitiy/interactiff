class RequestBlock < Block
  field :url, type: String, default: ""
  attr_accessible :url
  include WithVars
  with_vars :url


  def block_actions options
    delay(queue: "request").request options.merge(handler: nil)
  end

  def request options
    require 'net/http'
    Net::HTTP.get(URI.parse(url_with_vars options))
  end
end
