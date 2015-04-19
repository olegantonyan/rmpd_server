module ApplicationHelper
  
  def title(page_title)
    content_for :title, page_title.to_s
  end
  
  def localtime(utc_time)
    unless utc_time.nil?
      local_time utc_time, "%Y-%m-%d %H:%M:%S"
    else
      ""
    end
  end
  
  def flash_class(level)
    case level.to_sym
    when :info    then "alert alert-info"
    when :success then "alert alert-success"
    when :notice  then "alert alert-success"
    when :alert   then "alert alert-danger"
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

end
