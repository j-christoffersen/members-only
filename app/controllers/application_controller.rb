class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :logged_in?
  
  def log_in user
    user.remember
    cookies.permanent[:remember_token] = user.remember_token
    cookies.permanent[:user_id] = user.id
    user.save
    self.current_user = user
  end
  
  def sign_out
    self.current_user = nil
    cookies.permanent[:remember_token] = nil
    cookies.permanent[:user_id] = nil
  end
  
  def current_user
    @current_user ||= User.find_by(id: cookies.permanent[:user_id])
    unless @current_user == nil || BCrypt::Password.new(@current_user.remember_digest).is_password?(cookies.permanent[:remember_token])
      @current_user = nil
    end
    return @current_user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def logged_in_user
    unless logged_in?
      redirect_to login_path
    end
  end
  
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
end
