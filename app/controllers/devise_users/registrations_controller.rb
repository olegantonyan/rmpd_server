class DeviseUsers::RegistrationsController < Devise::RegistrationsController
  include AuthorizationSkipable

  def build_resource(hash_params = {})
    hash_params[:invitation_token] = params[:invitation_token] if params[:invitation_token]
    self.resource = User::Registration.new(hash_params)
  end

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    keys = %i(displayed_name allow_notifications company_title invitation_token)
    devise_parameter_sanitizer.permit(:sign_up, keys: keys)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    keys = %i(displayed_name allow_notifications)
    devise_parameter_sanitizer.permit(:sign_up, keys: keys)
    devise_parameter_sanitizer.permit(:account_update, keys: keys)
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
