class Mail::User < ActionMailer::Base
  def new_user(options={})
    options[:method_name] = 'new_user'
    options[:action] = "activate"
    setup(options)
  end
  
  def forgot_password(options)
    options[:method_name] = 'forgot_password'
    options[:action] = "new_password"
    setup(options)
  end
  
  private
    def method_name
      /`(.*)'/.match(caller.first).captures[0].to_s rescue nil
    end
  
    def setup(options)
      @options = options
      user = options[:user]
      generate_url
      recipients(user.email)
      from(t(:from))
      subject(t(:subject))
      sent_on Time.now
      content_type "text/html"
      part :content_type => "text/html", :body => t(:body, :url => @url)
    end
    
    def t(text, options={})
      I18n.t('actionmailer.user.' + @options[:method_name] + '.' + text.to_s, options)
    end
    
    def generate_url
      @url = "http://" + default_url_options[:host] + "/user/" + @options[:action] + "/" + @options[:user].hashed_password
    end
end
