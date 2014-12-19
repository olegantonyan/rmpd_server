class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #http_basic_authenticate_with name: "admin", password: "Qfflvbyxtu"
  
  def flash_error(msg)
    flash[:error] = msg.to_s
  end
  
  def flash_info(msg)
    flash[:info] = msg.to_s
  end
  
  def flash_success(msg)
    flash[:success] = msg.to_s
  end
  
  def flash_warning(msg)
    flash[:warning] = msg.to_s
  end
  
end
