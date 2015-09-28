class BaseController < ApplicationController
  include ActionView::Helpers::TextHelper
  include Pundit

  before_action :authenticate_user!
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  self.responder = ApplicationResponder
  respond_to :html

  #rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def result(object, options = {})
    method = options.fetch(:method, :save)
    method = :destroy if caller[0][/`.*'/][1..-2] == 'destroy'
    success_url = options.fetch(:success_url, object_url(object) || object_index_url(object) || :back)
    error_action = options.fetch(:error_action, object.persisted? ? :edit : :new)
    if object.send method
      flash_success(t('flash.actions.create.notice', resource_name: object.class.to_s))
      redirect_to success_url
    else
      flash_error(t('flash.actions.create.alert', resource_name: object.class.to_s, errors: object.errors.full_messages.to_sentence))
      render error_action
    end
  end

  def object_index_url object
    polymorphic_url(object.class)
  rescue NoMethodError
    nil
  end

  def object_url object
    polymorphic_url(object)
  rescue NoMethodError
    nil
  end

  def flash_success msg
    flash[:notice] = truncate_message(msg)
  end

  def flash_error msg
    flash[:alert] = truncate_message(msg)
  end

  def flash_warning msg
    flash[:warning] = truncate_message(msg)
  end

  def interpolation_options_for object
    @responders_resource = object
  end

  private

  #def interpolation_options
    #{ error_message: @responders_resource.errors.full_messages.to_sentence }
  #end

  def truncate_message msg
    truncate(msg.to_s, length: 256, escape: false)
  end

  def user_not_authorized
    redirect_to(request.referrer || root_path, flash_error(t(".user_no_authorized")))
  end

end
