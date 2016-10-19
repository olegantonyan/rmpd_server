require 'jwt'

class Authentication
  attr_accessor :algorithm, :secret

  def initialize(secret = Rails.application.secrets[:secret_key_base])
    self.algorithm = 'HS256'
    self.secret = secret
  end

  def issue(payload)
    JWT.encode(payload, secret, algorithm)
  end

  def decode(token)
    JWT.decode(token, secret, true, algorithm: algorithm).first
  end
end
