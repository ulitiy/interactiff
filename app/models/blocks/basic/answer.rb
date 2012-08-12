class Answer < Block
  field :body, type: String, default: ""
  field :reusable, type: Symbol, default: :for_other
  field :spelling_matters, type: Boolean, default: true #only if regexp is true and reusable is false
  attr_accessible :body

  # checks if the answer could be hot by the criteria of the reusability
  def reusable_hot? options
    case reusable
    when :for_all
      true
    when :for_other
      !is_hit? options
    when :no
      spelling_hot? options
    end
  end

  # checks if the answer could be hot by the criteria of the spelling (only when regexp)
  def spelling_hot? options
    if spelling_matters
      !events.where(body: Regexp.new(options[:input], "i")).any?
    else
      !is_hit_by_any?
    end
  end

  def body_hot? options
    options[:input] =~ Regexp.new(body, "i")
  end

  def hot? options
    body_hot?(options) && reusable_hot?(options)
  end
end
