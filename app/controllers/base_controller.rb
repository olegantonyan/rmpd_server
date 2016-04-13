class BaseController < ApplicationController
  include Pundit
  include CrudResponder

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  with_options unless: :devise_controller? do
    after_action :verify_authorized
    after_action :verify_policy_scoped, only: :index
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = t('.views.shared.not_authorized', default: "You don't have permissions to do this")
    redirect_back(fallback_location: root_path)
  end

  def configure_permitted_parameters
    keys = %i(displayed_name allow_notifications)
    devise_parameter_sanitizer.permit(:sign_up, keys: keys)
    devise_parameter_sanitizer.permit(:account_update, keys: keys)
  end
end
