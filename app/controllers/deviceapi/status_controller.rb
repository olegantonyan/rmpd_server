class Deviceapi::StatusController < ApplicationController
  before_filter :authenticate

  def index
    render json: { :ok => true }
  end
  
  def create
    RemoteInterface.new.received_message(credentials[:login], request.body)
  end

  private

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        puts "#{username} : #{password}"
        #TODO check auth
        return true
      end
    end
    
    def credentials
      username, password = ActionController::HttpAuthentication::Basic::user_name_and_password(request)
      {:login => username, :pass => password}
    end
    
  
end
