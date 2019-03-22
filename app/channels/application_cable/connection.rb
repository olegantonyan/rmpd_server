module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user # rubocop: disable Metrics/AbcSize it's fine here
      verified_user = User.find_by(id: cookies.encrypted['user.id'])
      if verified_user && cookies.encrypted['user.expires_at'] && Time.parse(cookies.encrypted['user.expires_at']).utc > Time.now.utc
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
