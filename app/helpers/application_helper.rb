module ApplicationHelper
  def title(page_title)
    content_for :title, page_title.to_s
  end

  def hide_navbar?
    params[:invitation_token].present? # hide navbar for those idiots who can't register via invite
  end

  def app_title
    return 'use load_config to initialize APP_CONFIG' unless defined? APP_CONFIG
    APP_CONFIG[:app_title] || 'set app_title in config/config.yml'
  end

  def icon_text(icon, text = '')
    icon(icon) + ' ' + text # font-awesome icon()
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
end
