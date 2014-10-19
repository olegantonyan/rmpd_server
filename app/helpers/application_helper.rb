module ApplicationHelper
  
  def title(page_title)
    content_for :title, page_title.to_s
  end
  
  def localtime(utc_time)
    local_time utc_time, "%Y-%m-%d %H:%M:%S"
  end
  
  def flash_class(level)
    case level.to_sym
    when :info    then "alert alert-info"
    when :success then "alert alert-success"
    when :error   then "alert alert-danger"
    when :warning then "alert alert-warning"
    end
end

end
