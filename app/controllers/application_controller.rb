class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_locale
    loc = params[:locale] || extract_locale_from_tld
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

  def user_not_authorized
    flash[:alert] = t('views.not_authorized')
    redirect_back(fallback_location: root_path)
  end

  def add_js_data(hash = {})
    @js_data = {
      i18n: Translations.all[:webpacker],
      companies: policy_scope(Company.all).pluck(:id, :title)&.map { |id, title| { id: id, title: title }.freeze },
      current_user: {
        root: current_user&.root? || false
      }
    }
    @js_data.merge!(hash)
    @js_data.freeze
  end
end
