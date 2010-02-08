module JsFlashActions
  def flash_and_redirect(options={})
    if options[:error]
      error_flash_translate(options[:error])
      options[:error] = nil
    end
    if options[:success]
      success_flash_translate(options[:success])
      options[:success] = nil
    end
    if options[:notice]
      notice_flash_translate(options[:notice])
      options[:notice] = nil
    end
    
    redirect_to options
  end
  
  def error_flash_translate(text, options={})
    flash_translate(:error, text, options)
  end

  def success_flash_translate(text, options={})
    flash_translate(:success, text, options)
  end
  
  def notice_flash_translate(text, options={})
    flash_translate(:notice, text, options)
  end
  
  def flash_translate(key, text, options={})
    flash[key] = t("actioncontroller." + text, options)
  end
end

ActionController::Base.send(:include, JsFlashActions)