# Include hook code here
require 'js_authorization'

ActionController::Base.send(:include, JsAuthorizationController)
ActiveRecord::Base.send(:extend, JsAuthorizationModel)