module ApplicationHelper
  
  def title(page_title)
    content_for :title, page_title.to_s
  end
  
  def localtime(utc_time)
    if utc_time != nil
      local_time utc_time, "%Y-%m-%d %H:%M:%S"
    else
      "<nil>"
    end
  end
  
  def flash_class(level)
    case level.to_sym
    when :info    then "alert alert-info"
    when :success then "alert alert-success"
    when :error   then "alert alert-danger"
    when :warning then "alert alert-warning"
    end
  end
  
  def active_class_for(*controller)
    if controller.include?(params[:controller])
      "active"
    else
      ""
    end
  end
  
  def select2js_for_id(id)
    javascript_tag "$(document).ready(function() { $('##{id.to_s}').select2(); });"
  end
  
  def broker_online?
    return RemoteInterface.new.server_online?
  end

end
