module ApplicationHelper

  # def map_for_select input, property, options={}
  #   options.reverse_merge!({include_blank: false})
  #   arr=[]
  #   arr=arr+[[nil,nil]] if options[:include_blank]
  #   arr=arr+(input||[]).map { |item| [property.to_proc.call(item),item.id] }
  # end

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

end
