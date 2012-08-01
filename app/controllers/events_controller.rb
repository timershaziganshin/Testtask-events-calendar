class EventsController < ApplicationController

  ONLY_REGISTERED = 'Only registered users can '

  before_filter :require_login
  before_filter :manage_only_own_events, :only => [:edit, :update, :destroy]
    
  def index # get /events
    @events = Event.all
    render :locals => { :all_events => true }
  end

  def my # get /myevents
    @events = current_user.events
    render 'index', :locals => { :all_events => false }
  end

  def show # get /events/:id
    @event = Event.find(params[:id])
    @comments = @event.comments
    @comment = Comment.new
    render
  end

  def new # get /events/new by ajax
    @event = Event.new
    render :partial => 'new'
  end

  def edit # get /events/:id/edit by ajax
    render :partial => 'edit'
  end

  def create # post /events
    @event = current_user.events.build(params[:event])

    if @event.save
      redirect_to @event, notice: 'Event was successfully created'
    else
      @event.errors.full_messages.each.with_index { |msg, index| flash[index] = msg }
      redirect_to events_path
    end
  end

  def update # put /events/:id
    if @event.update_attributes(params[:event])
      flash[:notice] = 'Changes saved'
    else
      @event.errors.full_messages.each.with_index { |msg, index| flash[index] = msg }
    end
    redirect_to @event
  end

  def destroy # delete /events/:id
    @event.destroy
    redirect_to :back, :notice => 'Event was succesfully deleted'
  end

  def by_date # get /events/bydate/:year/:month/:day/
    date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    @events = Event.events_at(date)
    render 'index', :locals => { :all_events => true, :date => date }
  rescue ArgumentError
    redirect_to events_path, :alert => 'Wrong date'
  end

  def my_by_date # get /myevents/bydate/:year/:month/:day
    date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    @events = current_user.events.events_at(date)
    render 'index', :locals => { :all_events => false, :date => date }
  rescue ArgumentError
    redirect_to myevents_path, :alert => 'Wrong date'
  end

  private

  def require_login
    if user_not_logged_in?
      redirect_to login_path, :alert => ONLY_REGISTERED + ' can view and manage events'
    end
  end

  def manage_only_own_events
    @event = Event.find(params[:id])

    if @event.user != current_user
      redirect_to @event, :alert => 'Users can manage only their events'
    end
  end
end
