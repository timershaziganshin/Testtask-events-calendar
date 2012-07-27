module ApplicationHelper
  def user_logged_in?
    !session[:user].nil?
  end

  def user_not_logged_in?
    !user_logged_in?
  end

end

