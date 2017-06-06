module Deviceapi
  class BaseController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :authenticate_and_set_device

    protected

    attr_reader :device

    private

    def authenticate_and_set_device
      authenticate_or_request_with_http_basic do |username, password|
        @device = Device.find_by(login: username).try(:authenticate, password)
        if @device
          true
        else
          render status: :forbidden, plain: 'Forbidden'
        end
      end
    end
  end
end
