require 'digest/md5'

# JsAuthorization
module JsAuthorizationController
  def self.included(instance)
    instance.helper_method :is_logged_in?, :not_logged_in?, :current_user
  end
  
  def is_logged_in?
    if current_user.nil?
      false
    else
      true
    end
  end

  def not_logged_in?
    if is_logged_in?
      false
    else
      true
    end
  end
  
  def current_user
    session[:user]
  end
  
  def reset_login
    session[:user] = nil
  end
end

module JsAuthorizationModel
  def encrypt(value)
    Digest::SHA1.hexdigest(value)
  end
end