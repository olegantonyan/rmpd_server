class Deviceapi::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  before_filter :authenticate_and_set_device

  protected

  attr_reader :device

  private

  def authenticate_and_set_device
    authenticate_or_request_with_http_basic do |username, password|
      @device = Device.find_by(login: username).try(:authenticate, password)
      if @device
        true
      else
        render status: :forbidden, text: 'Forbidden'
      end
    end
  end

end
