class CommentsController < ApplicationController

  before_filter :require_login

  def create # post /events/:event_id/comments
    @event = Event.find(params[:event_id])
    @comment = @event.comments.build(params[:comment])
    @comment.user_id = current_user_id

    unless @comment.save
      flash[:alert] = 'Error while saving comment'
    end
    redirect_to @event
  end

  private

  def require_login
    if user_not_logged_in?
      redirect_to login_path, :alert => 'Only registered users can comment events'
    end
  end
end
