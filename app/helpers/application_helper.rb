module ApplicationHelper
  def multiline_notice(notice)
    notice.to_s.gsub(/\n/, "<br/>").html_safe
  end
end
