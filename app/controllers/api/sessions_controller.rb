class Api::SessionsController < ActionController::API
  include Api::Concerns::Errors

  def create
    user = User.find_by!(email: auth_params[:login])
    if user.valid_password?(auth_params[:password])
      render json: { jwt: Authentication.new.issue(user_id: user.id) }
    else
      unauthorized!
    end
  end

  def auth_params
    params.permit(:login, :password)
  end
end
