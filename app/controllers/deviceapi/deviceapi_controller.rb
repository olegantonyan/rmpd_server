class Deviceapi::DeviceapiController < ApplicationController
  before_filter :authenticate_and_set_device
  #skip_before_filter :verify_authenticity_token
  
  protected
  
  attr_accessor :device
  
  private
  
  def authenticate_and_set_device
    authenticate_or_request_with_http_basic do |username, password|
      d = Device.find_by(:login => username).try(:authenticate, password)
      if d
        @device = d
        true
      else
        @device = nil
        render :status => :forbidden, :text => "Forbidden"
      end
    end
  end
    
end