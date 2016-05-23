class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit
  before_action :set_locale

  private

  def set_locale
    loc = params[:lang] || extract_locale_from_tld
    I18n.locale = loc if loc
  end

  def extract_locale_from_tld
    # Get locale from top-level domain or return nil if such locale is not available
    # You have to put something like:
    #   127.0.0.1 application.com
    #   127.0.0.1 application.it
    #   127.0.0.1 application.pl
    # in your /etc/hosts file to try this out locally
    request.host.split('.').last.presence_in(I18n.available_locales.map(&:to_s))
  end
end
