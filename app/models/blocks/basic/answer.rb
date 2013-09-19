# Potential input block
class Answer < Message
  include AttrSanitizer
  include WithVars
  with_vars :body

  field :body, type: String, default: ""
  sanitize :body
  # можешь активировать несколько раз один блок ответа "for_all"
  # ты не можешь, но другие могут :for_other
  # никто не может использовать один ответ :no
  field :reusable, type: String, default: "for_other"
  # другие могут активировать, если написание отличается
  field :spelling_matters, type: Boolean, default: false #only if regexp is true and reusable is no
  attr_accessible :body,:reusable,:spelling_matters

  before_create :set_digest

  # set the digest for link access to the answer
  def set_digest
    self.body=digest if self.body.empty?
    self.x=350
    self.y=brothers.where(_type: "Answer").order_by(y: 1).last.try(:y).to_i + 80 if parent_id
  end

  # the digest of id, that can be checked instead of input (fully replaceable)
  def digest
    Digest::MD5.hexdigest(id.to_s+Interactiff::Application.config.secret_token).to_i(16).to_s[3,8]
  end

  # checks if the answer could be hot by the criteria of the reusability
  def reusable_hot? options
    case reusable
    when "for_all"
      true
    when "for_other"
      !is_hit? options
    when "no"
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
    (task.input_type=="text" && options[:input] =~ Regexp.new(body, "i")) || (task.input_type!="text" && options[:input] == digest)
  end

  # override
  def hot? options
    body_hot?(options) && reusable_hot?(options)
  end

  # sets input to body if it's digest answer
  def create_event options
    options[:input]=body if task.input_type=="link"
    super options
  end
end
