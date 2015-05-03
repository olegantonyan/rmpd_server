class UsersApplicationController < ApplicationController
  include ActionView::Helpers::TextHelper
  include Pundit
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def set_locale
    #I18n.locale = params[:lang] || I18n.default_locale
    I18n.locale = extract_locale_from_tld || I18n.default_locale
  end
  
  #def default_url_options(options = {})
  #  { lang: I18n.locale }.merge options
  #end
  
  def extract_locale_from_tld
    # Get locale from top-level domain or return nil if such locale is not available
    # You have to put something like:
    #   127.0.0.1 application.com
    #   127.0.0.1 application.it
    #   127.0.0.1 application.pl
    # in your /etc/hosts file to try this out locally
    parsed_locale = request.host.split('.').last
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end
  
  protected
  
    def flash_success msg
      {:flash => {:notice => truncate_message(msg)}}
    end
    
    def flash_error msg
      {:flash => {:alert => truncate_message(msg)}}
    end
    
    def flash_warning msg
      {:flash => {:warning => truncate_message(msg)}}
    end
    
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:account_update) << :displayed_name
      devise_parameter_sanitizer.for(:sign_up) << :displayed_name
    end
  
  private 
  
    def truncate_message msg
      truncate(msg.to_s, length: 256, escape: false)
    end
    
    def user_not_authorized
      redirect_to(request.referrer || root_path, flash_error(t(".user_no_authorized")))
    end
    
end