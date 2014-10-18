module ApplicationHelper
  
  def title(page_title)
    content_for :title, page_title.to_s
  end
  
  def localtime(utc_time)
    local_time utc_time, "%Y-%m-%d %H:%M:%S"
  end

end
