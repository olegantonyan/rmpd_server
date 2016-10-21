class Api::BaseController < JSONAPI::ResourceController
  include Api::Concerns::Errors

  protect_from_forgery with: :null_session

  before_action :set_paper_trail_whodunnit

  before_action :authenticate_user

  attr_reader :current_user

  private

  def authenticate_user
    token = request.env['HTTP_AUTHORIZATION']&.scan(/Bearer (.*)$/)&.flatten&.last
    unauthorized! unless token
    auth = Authentication.new.decode(token)
    @current_user = User.find_by(id: auth['user_id'])
    unauthorized! unless current_user
  end
end
