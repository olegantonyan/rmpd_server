class UsersApplicationController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  http_basic_authenticate_with name: APP_CONFIG['username'], password: APP_CONFIG['password']
  before_action :set_locale

  def set_locale
    I18n.locale = params[:lang] || I18n.default_locale
  end
  
  def default_url_options(options = {})
    { lang: I18n.locale }.merge options
  end
  
  def flash_error(msg)
    flash[:error] = msg.to_s
  end
  
  def flash_info(msg)
    flash[:info] = msg.to_s
  end
  
  def flash_success(msg)
    flash[:success] = msg.to_s
  end
  
  def flash_warning(msg)
    flash[:warning] = msg.to_s
  end
    
end