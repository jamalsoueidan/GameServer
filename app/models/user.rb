#feature can disable new_user activation
class User < ActiveRecord::Base
  
  attr_accessor :password, :password_confirmation
  
  attr_protected :hashed_password, :is_active, :salt
  
  def User.authenticate(email, password)
    user = User.find(:first, :conditions => ["email = ?", email])
    if user.nil? || User.password_is_correct?(user, password)
      return nil
    else
      return user
    end
  end
  
  def User.password_is_correct?(user, password)
    user.hashed_password != User.encrypt(password + user.salt)
  end
  
  def User.activate(hashed_password)
    user = User.find_by_hashed_password(hashed_password)
    if user.nil? || user.is_active?
      return nil
    else
      user.update_attribute(:is_active, true)
    end
    return user
  end
  
  def User.request_new_password?(email)
    return false if email == ''
    user = User.find_by_email(email)
    if user.nil?
      return false
    end
    
    user.update_attribute(:requested_new_password, true)
    Mail::User.deliver_forgot_password(:user => user)
    return true
  end
  
  def User.create_reset_password(params)
    return nil unless params[:id]
    user = User.find_by_hashed_password(params[:id])
    if user.nil?
      return nil
    end
    
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    return user
  end
  
  def is_not_active?
    return true unless is_active?
  end
    
  def password=(value)
    @password = value
    self.salt = User.encrypt(Time.now.to_s)
    self.hashed_password = User.encrypt(value + self.salt)
  end
  
  private
    def send_new_user_email
      return unless password
      Mail::User.deliver_new_user(:user => self)
    end
    
    def email_not_blank 
      return true unless email.blank? 
    end
    
    def password_not_blank
      return true unless password.blank?
    end
    
  after_create :send_new_user_email
  
  validates_presence_of :email, :name, :password, :on => :create
  validates_uniqueness_of :email, :name
  validates_length_of :password, :within => 5..40, :if => :password_not_blank
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => I18n.t("activerecord.errors.models.user.attributes.email.invalid"), :if => :email_not_blank
  validates_confirmation_of :password 
end
