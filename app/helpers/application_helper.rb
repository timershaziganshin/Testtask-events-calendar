module ApplicationHelper
  def user_logged_in?
    !session[:user].nil?
  end

  def user_not_logged_in?
    !user_logged_in?
  end
  
  def current_user
    User.find(session[:user])
  end
end

