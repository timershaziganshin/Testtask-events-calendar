class UsersController < ApplicationController

  require 'digest/md5'

  respond_to :html

  ALREADY_LOGGED = 'You are already logged in'
  NOT_LOGGED = 'You are not logged in'
  SAVING_ERRORS = 'Following'
  
  def show # get /profile
    if user_logged_in?
      @user = current_user
      render
    else      
      redirect_to login_path, :notice => NOT_LOGGED
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
      params[:user][:password] = Digest::MD5.hexdigest(params[:user][:password])
      user = User.find_by_email_and_password(params[:user][:email], params[:user][:password])      
      if user.nil?
        flash[:notice] = 'Wrong email/password'
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
        flash[:notice] = user.errors.full_messages.join("\n")
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
        flash[:notice] = user.errors.full_messages.join("\n")
      end
      redirect_to profile_path      
    else
      redirect_to login_path, :notice => NOT_LOGGED
    end 
  end

  def logout # any /logout
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
      redirect_to login_path, :notice => NOT_LOGGED
    end
  end
end
