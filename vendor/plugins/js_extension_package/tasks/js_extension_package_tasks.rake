#namespace :js_extension_package do
#  desc "Copies all the stylesheet files to your public/stylesheets folder"
#  task :install  do
#    plugin_root = RAILS_ROOT + "/vendor/plugins/js_extension_package"
#    
#    copy plugin_root + "/public/stylesheets/default.css", RAILS_ROOT + "/public/stylesheets/default.css"
#    copy plugin_root + "/public/stylesheets/application.css", RAILS_ROOT + "/public/stylesheets/application.css"
#    
#    puts ""
#    puts ""
#    puts ""
#    puts ""
#    
#    puts "Now default.css and application.css is copied to your stylesheet folder public/stylesheets"
#    
#    puts "Include it in your layout file as follow"
#    
#    puts '<%= stylesheet_link_tag "default" %>'
#    puts '<%= stylesheet_link_tag "application" %>'
#    
#    puts ""
#    puts ""
#    puts ""
#    puts ""
#  end
#end
