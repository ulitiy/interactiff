# Potential input block
class Answer < Block
  field :body, type: String, default: ""
  # можешь активировать несколько раз один блок ответа :for_all
  # ты не можешь, но другие могут :for_other
  # никто не может использовать один ответ :no
  field :reusable, type: Symbol, default: :for_other
  # другие могут активировать, если написание отличается
  field :spelling_matters, type: Boolean, default: true #only if regexp is true and reusable is no
  field :container_source, type: Boolean, default: false
  attr_accessible :body,:container_source,:reusable,:spelling_matters

  before_create :set_digest

  # set the digest for link access to the answer
  def set_digest
    self.body=digest if self.body.empty?
  end

  # the digest of id, that can be checked instead of input (fully replaceable)
  def digest
    Digest::MD5.hexdigest(id.to_s+Interactiff::Application.config.secret_token).to_i(16).to_s[3,8]
  end

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

  # checks if the answer text itself is correct
  def body_hot? options
    options[:input] =~ Regexp.new(body, "i") || options[:input] == digest
  end

  # override
  def hot? options
    body_hot?(options) && reusable_hot?(options)
  end
end
