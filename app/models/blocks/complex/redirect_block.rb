class RedirectBlock < Block
  field :url, type: String, default: ""
  attr_accessible :url
  include WithVars
  with_vars :url

end
