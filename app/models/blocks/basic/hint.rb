class Hint < Block
  include AttrSanitizer
  include WithVars
  with_vars :body
  field :body, type: String, :default => ""
  sanitize :body, chain: false

  attr_accessible :body

end
