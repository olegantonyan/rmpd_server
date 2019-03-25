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
    locale = params[:locale]
    I18n.locale = locale if locale.presence_in(I18n.available_locales.map(&:to_s))
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
