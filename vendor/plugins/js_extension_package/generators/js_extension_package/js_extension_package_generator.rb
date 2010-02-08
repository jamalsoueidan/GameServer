class JsExtensionPackageGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "assets/default.css", "public/stylesheets/default.css"
      m.file "assets/application.css", "public/stylesheets/application.css"
      m.readme "INSTALL"
    end
  end
  
  def file_name  
    ""
  end
end