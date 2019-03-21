module ApplicationHelper
  def hide_navbar?
    params[:invitation_token].present? # hide navbar for those idiots who can't register via invite
  end

  def app_title
    return 'use load_config to initialize APP_CONFIG' unless defined? APP_CONFIG
    APP_CONFIG[:app_title] || 'set app_title in config/config.yml'
  end
end
