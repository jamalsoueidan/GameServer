class JsFormBuilder < ActionView::Helpers::FormBuilder

  %w[text_field text_area password_field check_box select].each do |method_name| 
    define_method(method_name) do |field_name, *args|
       options = args.extract_options!
       initializeObject(method_name, options, field_name, super).build
     end
   end
  
  def terms_of_service(text)
    initializeObject("terms_of_service", {:label => text}, "terms_of_service").build
  end
  
  def submit_or_cancel(options={})    
    initializeObject("submit_or_cancel", options, "submit_or_cancel").build
  end
  
  def submit(options={})
    initializeObject("submit", options, "submit").build
  end
  
  def check_boxes(field_name, object, options={})
    instance = initializeObject("check_boxes", options, field_name)
    instance.model = object
    instance.build
  end
  
  private
    def initializeObject(method_name, options, input_name, input_tag = nil)
      instance = Object.const_get(method_name.gsub('_', ' ').titleize.gsub(' ', '')).new
      instance.builder = self
      instance.template = @template
      instance.options = options
      instance.method_name = method_name
      instance.input_name = input_name
      if input_tag
        instance.input_tag = input_tag
      end
      return instance
    end
end

# f.text_field :nas, :label => "someting", :around_label => {:tag => :div, :html => {:id => "lol"}}, :show_error => :on_field, :required => true,