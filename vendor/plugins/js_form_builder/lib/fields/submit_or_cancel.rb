class SubmitOrCancel < InputBaseClass
  def build
    submit_tag = template.submit_tag(submit_value, :id => builder.object_name.to_s + "_submit")
    cancel_tag = template.link_to(cancel_label, cancel_link)
    both = content_tag(:div, submit_tag + " or " + cancel_tag, :class => "submit_or_cancel")
    content_tag(:div, both, :class => "submit")
  end
  
  private
    def submit_value
      value = "Save changes"
      if options[:submit] && options[:submit][:label]
        return options[:submit][:label]
      end
      return value
    end
  
    def cancel_label
      if options[:cancel] && options[:cancel][:label]
        return options[:cancel][:label]
      end
      return "Cancel"
    end
    
    def cancel_link
      if options[:cancel]
        return options[:cancel][:url]
      end
      return :back
    end
end