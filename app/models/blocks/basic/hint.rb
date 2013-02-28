class Hint < Block
  # include AttrSanitizer
  include WithVars
  with_vars :body
  field :body, type: String, :default => ""
  # sanitize :body

  attr_accessible :body

end
