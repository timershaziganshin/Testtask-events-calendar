class UsersController < ApplicationController

  ALREADY_LOGGED = 'You are already logged in'
  NOT_LOGGED = 'You are not logged in'

  before_filter :require_login, :except => [:login, :process_login, :new, :create]
  before_filter :require_no_login, :only => [:login, :process_login, :new, :create]

  def show # get /profile
    @user = current_user
    render
  end

  def login # get /login
    @user = User.new
    render
  end

  def process_login # post /login
    @user = User.auth(params[:user][:email], params[:user][:password])
    if @user.nil?
      flash[:alert] = 'Wrong email/password'
      @user = User.new
      render 'login'
    else
      session[:user] = @user.id
      redirect_to profile_path, :notice => 'Successfully logged in'
    end
  end

  def new # get /register
    @user = User.new
    render
  end

  def create # post /register
    @user = User.new(params[:user])
    if @user.save
      session[:user] = @user.id
      redirect_to profile_path, :notice => 'Successfully registered'
    else
      @user.errors.full_messages.each.with_index { |msg, index| flash[index] = msg }
      redirect_to register_path
    end
  end

  def update # put /profile
    @user = current_user
    if params[:user][:password].empty?
      params[:user][:password] = @user.password
      params[:user][:password_confirmation] = nil
    end
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Changes saved'
    else
      @user.errors.full_messages.each.with_index { |msg, index| flash[index] = msg }
    end
    redirect_to profile_path
  end

  def logout # delete /logout
    session[:user] = nil
    redirect_to login_path
  end

  def edit # get /profile/edit by ajax
    @user = current_user
    render
  end

  private

  def require_login
    if user_not_logged_in?
      redirect_to login_path, :alert => NOT_LOGGED
    end
  end

  def require_no_login
    if user_logged_in?
      redirect_to profile_path, :alert => ALREADY_LOGGED
    end
  end
end
