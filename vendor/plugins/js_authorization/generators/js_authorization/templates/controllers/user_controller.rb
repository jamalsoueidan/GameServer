class UserController < ApplicationController  

  def index
    redirect_to :action => "login" if not_logged_in?
  end
  
  def login
    return unless request.post? 
    user = User.authenticate(params[:user][:email], params[:user][:password])
    if user.nil?
      error_flash_translate("user.login.wrong_password")
    elsif user.is_not_active?
      notice_flash_translate("user.login.not_active")
    else
      session[:user] = user
      current_user = "Lol"
    end
    
    if user.nil? || user.is_not_active?
      redirect_to :action => :login
    else
      redirect_to :root
    end
  end
  
  def signup
    return unless request.post? 
    @user = User.new(params[:user])
    if @user.save
      flash_and_redirect(:success => "user.signup.success", :action => :index)
    else
      flash.now[:error] = tt("user.signup.invalid")
    end
  end
  
  def activate
    if params[:id]
      user = User.activate(params[:id])
    end
    
    if user.nil?
      flash_and_redirect(:error => "user.activate.invalid", :action => :login)
    else
      session[:user] = user
      flash_and_redirect(:success => "user.activate.success", :action => :index)
    end
  end
  
  def forgot_password
    if request.post?
      if User.request_new_password?(params[:user][:email])
        flash_and_redirect(:success => "user.forgot_password.success", :action => :login)
      else
        flash_and_redirect(:error => "user.forgot_password.invalid", :action => :forgot_password)
      end
    end
  end
  
  def new_password
    if params[:id]
      user = User.find_by_hashed_password(params[:id])
    end
    
    if user.nil?
      flash_and_redirect(:error => "user.new_password.invalid", :action => :index)
    else
      if post?
        @user = User.create_reset_password(params[:user])
        if @user.save
          session[:user] = @user
          flash_and_redirect(:success => "user.new_password.success", :action => :index)
        end
      end
    end
  end
  
  def logout
    reset_login
    flash_and_redirect(:success => "user.logout.success", :action => :login)
  end
  
  def terms_of_service
    render :text => tt("user.terms_of_service.text")
  end
  
  filter_parameter_logging :password
end
