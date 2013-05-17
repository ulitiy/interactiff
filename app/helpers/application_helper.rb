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
    controller.class.name=~/Refinery/ ? refinery : self
  end

end
