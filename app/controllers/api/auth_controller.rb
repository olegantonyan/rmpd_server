module Api
  class AuthController < Api::BaseController
    include Api::Concerns::Errors
    include Api::Concerns::Authenticatable

    skip_before_action :authenticate_user, except: %i[refresh]

    def login
      user = User.find_by(email: login_params[:login])
      if user&.valid_password?(login_params[:password])
        render_jwt_for(user)
      else
        unauthorized!
      end
    end

    def refresh
      render_jwt_for(current_user)
    end

    def registration
      reg = User::RegistrationService.new(registration_params)
      if reg.save
        render json: { result: 'ok' }
      else
        render json: { errors: reg.errors, error_message: reg.errors.full_messages.to_sentence }, status: 422
      end
    end

    private

    def login_params
      params.permit(:login, :password)
    end

    def registration_params
      params.permit(*User::RegistrationService.attributes)
    end
  end
end
