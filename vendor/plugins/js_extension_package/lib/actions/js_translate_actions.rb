module JsTranslateActions
  def self.included(instance)
    instance.helper_method :tt
    instance.before_filter :set_locale
  end
  
  def tt(text, options={})
    t("actioncontroller." + text, options)
  end
  
  def set_locale
    if params[:locale]
      locale = params[:locale]
    end
    
    if locale.nil?
      locale = session[:locale]
    end
    
    if locale.nil?
      locale = request.env["HTTP_ACCEPT_LANGUAGE"][/[^,;]+/].to_s[0..1]
    end
    
    if locale != I18n.default_locale
      session[:locale] = locale
    end
    
    I18n.locale = locale
  end
end

ActionController::Base.send(:include, JsTranslateActions)