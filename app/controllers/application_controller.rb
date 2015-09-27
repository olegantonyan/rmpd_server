class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def set_locale
    I18n.locale = extract_locale_from_tld || I18n.default_locale
  end

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

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << [:displayed_name, :allow_notifications]
    devise_parameter_sanitizer.for(:sign_up) << [:displayed_name, :allow_notifications]
  end

end
