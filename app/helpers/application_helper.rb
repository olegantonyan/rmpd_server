module ApplicationHelper
  
  def title(page_title)
    content_for :title, page_title.to_s
  end
  
  def app_title
    APP_CONFIG[:app_title] || "set app_title in config/config.yml"
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
    javascript_tag "$(document).ready(function() { $('##{id.to_s}').select2({ width: '100%' }); });"
  end
  
  def row_info title, value, value_class="", title_class=""
    render partial: 'shared/row_info', locals: {title: title, value: value || "", value_class: value_class, title_class: title_class}
  end
  
  def list_with_links collection, attr_title
    ("<ul class='list-group'>" + 
    collection.map{|g| "<li class='list-group-item'>" + link_to(sanitize(eval("g.#{attr_title}")), g) + "</li>"}.join('') + 
    "</ul>").html_safe
  end
  
  def current_user_displayed_name
    current_user.displayed_name.blank? ? current_user.email : current_user.displayed_name
  end
  
  def icon_link_to(icon, text)
    raw("<i class='glyphicon #{icon}'></i> #{text}")
  end

end
