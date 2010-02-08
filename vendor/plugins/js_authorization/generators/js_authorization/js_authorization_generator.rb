class JsAuthorizationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      # initializers
      m.file "config/initializers/js_authorization_mail.rb", "config/initializers/js_authorization_mail.rb"
      m.file "config/initializers/js_authorization_locale.rb", "config/initializers/js_authorization_locale.rb"
      
      # locales
      m.directory "config/locales/js_authorization"
      m.file "config/locales/js_authorization/da.yml", "config/locales/js_authorization/da.yml"
      m.file "config/locales/js_authorization/en.yml", "config/locales/js_authorization/en.yml"
      
      # controllers
      m.file "controllers/user_controller.rb", "app/controllers/user_controller.rb" 

      # models
      m.file "models/user.rb", "app/models/user.rb"

      # views
      m.directory "app/views/user"
      m.file "views/user/index.erb", "app/views/user/index.erb"
      m.file "views/user/login.erb", "app/views/user/login.erb"
      m.file "views/user/signup.erb", "app/views/user/signup.erb"
      m.file "views/user/new_password.erb", "app/views/user/new_password.erb"
      m.file "views/user/forgot_password.erb", "app/views/user/forgot_password.erb"

      # migration
      m.migration_template "migrate/create_users.rb", "db/migrate"
      
      # install readme file.
      m.readme "INSTALL"
    end
  end
  
  def file_name  
    "create_users"
  end
end