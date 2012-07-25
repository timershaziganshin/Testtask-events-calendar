class EventsController < ApplicationController

  respond_to :html

  ONLY_REGISTERED = 'Only registered users can '
  
  def index # get /events
    if user_logged_in?     
      @events = Event.all  
      render :locals => { :all_events => true } 
    else       
      redirect_to login_path, :error => ONLY_REGISTERED + 'view events'
    end 
  end

  def my # get /myevents
    if user_logged_in?
      @events = current_user.events
      render 'index', :locals => { :all_events => false }
    else
      redirect_to login_path, :notice => ONLY_REGISTERED + 'view events'
    end 
  end

  def comment # post /events/:id/comment
    if user_logged_in?
      @event = Event.find(params[:id])      
      @comment = @event.comments.build(params[:comment])
      @comment.user_id = current_user_id

      if !@comment.save    
        flash[:notice] = 'Error while saving comment'
      end
      redirect_to @event
    else
      redirect_to login_path, :notice => ONLY_REGISTERED + 'comment events'
    end
  end

  def show # get /events/:id
    if user_logged_in?
      @event = Event.find(params[:id])
      @comments = @event.comments          
      @comment = Comment.new 
      render
    else 
      redirect_to login_path, :notice => ONLY_REGISTERED + 'view comments'
    end
  end

  def new # get /events/new by ajax
    if user_logged_in?
      @event = Event.new
      render :partial => 'new'
    else 
      redirect_to login_path, :notice => ONLY_REGISTERED + 'create events'
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
      redirect_to login_path, :notice => ONLY_REGISTERED + 'edit events'
    end
  end

  def create # post /events
    if user_logged_in?
      @event = current_user.events.build(params[:event])
    
      if @event.save
        redirect_to @event, notice: 'Event was successfully created'
      else
        flash[:notice] = @event.errors.full_messages.join("\n")
        redirect_to events_path
      end
    else
      redirect_to login_path, :notice => ONLY_REGSITERED + 'create events'
    end
  end

  def update # put /events/:id
    if user_logged_in?    
      @event = Event.find(params[:id])
      if @event.user == current_user
        if @event.update_attributes(params[:event])
          flash[:notice] = 'Changes saved'
        else
          flash[:notice] = @event.errors.full_messages.join("\n")
        end
        redirect_to @event
      else
        redirect_to @event, :notice => 'Users can edit only their events'
      end
    else
      redirect_to login_path, :notice => ONLY_REGSITERED + 'edit events'
    end
  end

  def destroy # delete /events/:id
    if user_logged_in?
      @event = Event.find(params[:id])
      if @event.user == current_user
        @event.destroy
        redirect_to events_path, :notice => 'Event was succesfully deleted'
      else
        redirect_to @event, :notice => 'Users can delete only their events'
      end
    else
      redirect_to login_path, :notice => ONLY_REGSITERED + 'delete events'
    end
  end
end
