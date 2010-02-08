class TermsOfService < InputBaseClass
  def build
    content = content_tag(:div, "", :class => "label")
    input_tag = options[:label]
    content += input_tag
    content_tag(:div, content, :class => "row")
  end
end