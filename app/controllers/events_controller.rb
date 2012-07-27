class EventsController < ApplicationController

  ONLY_REGISTERED = 'Only registered users can '
    
  def index # get /events
    if user_logged_in?     
      @events = Event.all  
      render :locals => { :all_events => true } 
    else       
      redirect_to login_path, :alert => ONLY_REGISTERED + 'view events'
    end 
  end

  def my # get /myevents
    if user_logged_in?
      @events = current_user.events
      render 'index', :locals => { :all_events => false }
    else
      redirect_to login_path, :alert => ONLY_REGISTERED + 'view events'
    end 
  end

  def show # get /events/:id
    if user_logged_in?
      @event = Event.find(params[:id])
      @comments = @event.comments          
      @comment = Comment.new 
      render
    else 
      redirect_to login_path, :alert => ONLY_REGISTERED + 'view comments'
    end
  end

  def new # get /events/new by ajax
    if user_logged_in?
      @event = Event.new
      render :partial => 'new'
    else 
      redirect_to login_path, :alert => ONLY_REGISTERED + 'create events'
    end
  end

  def edit # get /events/:id/edit by ajax
    if user_logged_in?       
      @event = Event.find(params[:id])
      if @event.user == current_user
        render :partial => 'edit'
      else
        render 'public/404.html' 
      end
    else 
      redirect_to login_path, :alert => ONLY_REGISTERED + 'edit events'
    end
  end

  def create # post /events
    if user_logged_in?
      @event = current_user.events.build(params[:event])
    
      if @event.save
        redirect_to @event, notice: 'Event was successfully created'
      else
        @event.errors.full_messages.each.with_index { |msg, index| flash[index] = msg }
        redirect_to events_path
      end
    else
      redirect_to login_path, :alert => ONLY_REGSITERED + 'create events'
    end
  end

  def update # put /events/:id
    if user_logged_in?    
      @event = Event.find(params[:id])
      if @event.user == current_user
        if @event.update_attributes(params[:event])
          flash[:notice] = 'Changes saved'
        else
          @event.errors.full_messages.each.with_index { |msg, index| flash[index] = msg }
        end
        redirect_to @event
      else
        redirect_to @event, :alert => 'Users can edit only their events'
      end
    else
      redirect_to login_path, :alert => ONLY_REGSITERED + 'edit events'
    end
  end

  def destroy # delete /events/:id
    if user_logged_in?
      @event = Event.find(params[:id])
      if @event.user == current_user
        @event.destroy
        redirect_to :back, :notice => 'Event was succesfully deleted'
      else
        redirect_to @event, :alert => 'Users can delete only their events'
      end
    else
      redirect_to login_path, :alert => ONLY_REGSITERED + 'delete events'
    end
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
end
