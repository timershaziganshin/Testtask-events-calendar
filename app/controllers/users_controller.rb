class UsersController < ApplicationController

  ALREADY_LOGGED = 'You are already logged in'
  NOT_LOGGED = 'You are not logged in'
  
  def show # get /profile
    if user_logged_in?
      @user = current_user
      render
    else      
      redirect_to login_path, :alert => NOT_LOGGED
    end
  end

  def login # get /login
    if user_not_logged_in?
      @user = User.new
      render
    else      
      redirect_to profile_path, :notice => ALREADY_LOGGED
    end
  end

  def process_login # post /login
    if user_not_logged_in?      
      user = User.auth(params[:user][:email], params[:user][:password])      
      if user.nil?
        flash[:alert] = 'Wrong email/password'
        @user = User.new
        render 'login'
      else
        session[:user] = user.id
        redirect_to profile_path, :notice => 'Successfully logged in'
      end
    else
      redirect_to profile_path, :notice => ALREADY_LOGGED
    end
  end

  def new # get /register
    if user_not_logged_in?
      @user = User.new 
      render   
    else
      redirect_to profile_path, :notice => ALREADY_LOGGED
    end
  end

  def create # post /register
    if user_not_logged_in?
      user = User.new(params[:user])
      if user.save
        session[:user] = user.id        
        redirect_to profile_path, :notice => 'Successfully registered'
      else             
        user.errors.full_messages.each.with_index { |msg, index| flash[index] = msg }
        redirect_to register_path
      end
    else
      redirect_to profile_path, :notice => ALREADY_LOGGED
    end
  end

  def update # put /profile
    if user_logged_in?   
      user = current_user
      if params[:user][:password].empty?
        params[:user][:password] = user.password
        params[:user][:password_confirmation] = nil
      end
      if user.update_attributes(params[:user])
        flash[:notice] = 'Changes saved'
      else
        user.errors.full_messages.each.with_index { |msg, index| flash[index] = msg }
      end
      redirect_to profile_path      
    else
      redirect_to login_path, :alert => NOT_LOGGED
    end 
  end

  def logout # delete /logout
    if user_logged_in?   
      session[:user] = nil
      redirect_to login_path
    else
      redirect_to login_path, :notice => NOT_LOGGED
    end
  end

  def edit # get /profile/edit by ajax
    if user_logged_in?
      @user = current_user
      render
    else
      redirect_to login_path, :alert => NOT_LOGGED
    end
  end
end
