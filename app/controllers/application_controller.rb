class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected 
    
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:account_update) << :displayed_name
      devise_parameter_sanitizer.for(:sign_up) << :displayed_name
    end
end
