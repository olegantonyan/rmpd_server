class BaseController < ApplicationController
  include ActionView::Helpers::TextHelper
  include Pundit
  include CrudResponder

  before_action :authenticate_user!
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def flash_success(msg)
    flash[:notice] = truncate_message(msg)
  end

  def flash_error(msg)
    flash[:alert] = truncate_message(msg)
  end

  def flash_warning(msg)
    flash[:warning] = truncate_message(msg)
  end

  private

  def truncate_message(msg)
    truncate(msg.to_s, length: 256, escape: false)
  end

  # def user_not_authorized
  #   redirect_to(request.referrer || root_path, flash_error(t('.user_no_authorized')))
  # end
end
