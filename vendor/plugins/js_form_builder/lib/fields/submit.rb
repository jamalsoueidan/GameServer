class Submit < InputBaseClass
  def build
    value = submit_tag_value
    if options.class.to_s == "String"
      value = options
    end
    submit_tag = template.submit_tag(value, :id => builder.object_name.to_s + "_submit")
    content_tag(:div, submit_tag, :class => "submit")
  end
  
  private
     def submit_tag_value
        value = "Save changes"
        if options[:label]
          return options[:label]
        elsif options[:submit_label]
          return options[:submit_label]
        end 
        return value
      end
end