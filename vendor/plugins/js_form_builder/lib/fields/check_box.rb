class CheckBox < InputBaseClass
  def build
    text_beside_check_box = content_tag(:label, check_box_value, :for => builder.object_name.to_s + "_" + input_name.to_s, :style => "cursor:pointer")
    content = content_tag(:div, input_tag + " " + text_beside_check_box, :class => "label")
    content_tag(:div, content, :class => "row")
  end
  
  private
    def check_box_value
      if options[:label]
        return options[:label]
      end
      return " "
    end
end