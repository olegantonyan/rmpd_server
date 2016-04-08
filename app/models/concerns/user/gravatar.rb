module User::Gravatar
  extend ActiveSupport::Concern

  def gravatar_url
    @_gravatar_url ||= "https://gravatar.com/avatar/#{Digest::MD5.hexdigest(email).downcase}.png"
  end
end
