module JsLinkHelpers
  def link_back(text = nil)
    if text.nil?
      text = "Back"
    end
    
    link_to(text, :back)
  end
  
  def link_popup(text, options = {})
    if options.nil?
      options = {}
    end
    
    link_to(text, options, :popup => ['new_window_name', 'height=300,width=600,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes'])
  end
end

ActionView::Base.send(:include, JsLinkHelpers)