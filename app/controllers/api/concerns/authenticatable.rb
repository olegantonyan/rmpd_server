module Api
  module Concerns
    module Authenticatable
      extend ActiveSupport::Concern

      included do
        prepend_before_action :authenticate_user
      end

      private

      def authenticate_user
        token = request.env['HTTP_AUTHORIZATION']&.scan(/Bearer (.*)$/)&.flatten&.last
        unauthorized! unless token
        auth = Authentication.new.decode(token)
        @_current_user = User.find_by(id: auth['user_id'])
        unauthorized_error! unless current_user
      end

      def current_user
        @_current_user
      end

      def unauthorized_error!
        raise Api::Concerns::Errors::UnauthorizedError, 'unauthorized'
      end

      def serialize_user_for_jwt(user)
        { user_id: user.id }
      end

      def render_jwt_for(user)
        render json: { jwt: Authentication.new.issue(serialize_user_for_jwt(user)) }
      end
    end
  end
end
