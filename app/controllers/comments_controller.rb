class CommentsController < ApplicationController

  def create # post /events/:event_id/comments
    if user_logged_in?
      @event = Event.find(params[:event_id])
      @comment = @event.comments.build(params[:comment])
      @comment.user_id = current_user_id
      
      unless @comment.save
        flash[:alert] = 'Error while saving comment'
      end
      redirect_to @event
    else
      redirect_to login_path, :alert => 'Only registered users can comment events'
    end
  end

end
