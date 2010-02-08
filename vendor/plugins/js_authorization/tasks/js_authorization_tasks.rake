namespace :js_authorization do
  desc "Installation..."
  task :install do
    system "ruby script/generate controller user"
  end  
end