module EventsHelper
  def repeated(period)
    res = case period
          when Event::NO_PERIOD then ''
          when Event::DAILY then 'This event repeated every day.'
          when Event::WEEKLY then 'This event repeated every week.'
          when Event::MONTHLY then 'This event repeated every month.'
          when Event::YEARLY then 'This event repeated every year.'     
          end 
  end

  def my_event?(event)
    session[:user] == event.user_id
  end
end
