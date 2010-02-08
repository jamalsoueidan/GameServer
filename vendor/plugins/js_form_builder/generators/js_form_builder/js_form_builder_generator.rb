class JsFormBuilderGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "assets/form.css", "public/stylesheets/form.css"
      m.readme "INSTALL"
    end
  end
  
  def file_name  
    ""
  end
end