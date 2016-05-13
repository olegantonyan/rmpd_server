class BaseController < ApplicationController
  include Pundit
  include CrudResponder

  before_action :authenticate_user!
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = t('.views.shared.not_authorized', default: "You don't have permissions to do this")
    redirect_back(fallback_location: root_path)
  end
end
