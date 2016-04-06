module ApplicationHelper
  def title(page_title)
    content_for :title, page_title.to_s
  end

  def app_title
    return 'use load_config to initialize APP_CONFIG' unless defined? APP_CONFIG
    APP_CONFIG[:app_title] || 'set app_title in config/config.yml'
  end

  def localtime(utc_time)
    return '' unless utc_time
    local_time(utc_time, '%Y-%m-%d %H:%M:%S')
  end

  def icon_text(icon, text = '')
    icon(icon) + ' ' + text
  end

  def flash_class(level)
    case level.to_sym
    when :info
      'alert alert-info'
    when :success, :notice
      'alert alert-success'
    when :alert, :error
      'alert alert-danger'
    when :warning
      'alert alert-warning'
    end
  end

  def active_class_for(*controller)
    controller.include?(params[:controller]) ? 'active' : ''
  end

  def icon_link_to(icon, text)
    raw("<i class='glyphicon glyphicon-#{icon}'></i> #{text}")
  end
end
