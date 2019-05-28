class Recaptcha
  class << self
    def enabled?
      Rails.env.production?
    end
  end

  attr_reader :recaptcha_response

  def initialize(recaptcha_response)
    @recaptcha_response = recaptcha_response
  end

  def valid?
    return true unless self.class.enabled?
    response = perform_request
    Rails.logger.debug("recaptcha response for #{recaptcha_response}: #{response}")
    response['success'] == true
  rescue StandardError
    false
  end

  private

  def secret_key
    Rails.application.secrets.recaptcha_key || raise('please provide RECAPTHA_SECRET_KEY')
  end

  def uri
    URI('https://www.google.com/recaptcha/api/siteverify')
  end

  def request_params
    {
      secret: secret_key,
      response: recaptcha_response
    }.freeze
  end

  def perform_request # rubocop: disable Metrics/AbcSize I don't care here
    http = ::Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 5
    http.read_timeout = 5
    http.ssl_timeout = 5
    http.use_ssl = uri.scheme == 'https'

    headers = { 'Accept' => 'application/json' }
    request = Net::HTTP::Post.new(uri, headers)
    request.set_form_data(request_params)
    JSON.parse(http.request(request).body)
  end
end
