class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :user_logged_in?, :user_not_logged_in?, :current_user

  def user_logged_in?
    !session[:user].nil?
  end

  def user_not_logged_in?
    !user_logged_in?
  end

  def current_user
    @current_user ||= User.find(session[:user])
  end

  def current_user_id
    session[:user]
  end
end
