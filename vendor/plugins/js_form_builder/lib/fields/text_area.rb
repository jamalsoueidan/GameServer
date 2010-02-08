class TextArea < InputBaseClass
  def build
    content = label_object
    content += input_object
    content_tag(:div, content, :class => input_style)
  end
end