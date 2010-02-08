class CheckBoxes < InputBaseClass
  
  attr_accessor :model
  
  def build
    @input_tag = ""
    
    model.each do |m|
      id_tag = input_name.to_s + "_" + m[1].to_s
      content = template.check_box_tag(builder.object_name.to_s + "[" + input_name.to_s + "][]", m[1].to_s, includes_selections?(m[1]), :id => id_tag, :onchange => options[:onchange])
      content += content_tag(:label, m[0], :for => id_tag, :style => "cursor:pointer")
      @input_tag += content_tag(:div, content, :class => "check_box")
    end
    
    content = label_object
    content += input_object
    content_tag(:div, content, :class => input_style)
  end
  
  private
    def check_box_value
      if options[:label]
        return options[:label]
      end
      return " "
    end
    
    def includes_selections?(id)
      if has_object?
        selections = builder.object.send(input_name)
        if selections && selections.include?(id.to_s)
          return true
        end
      end
      return false
    end
end