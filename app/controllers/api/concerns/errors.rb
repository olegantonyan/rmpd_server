module Api::Concerns::Errors
  extend ActiveSupport::Concern

  class UnauthorizedError < RuntimeError; end

  included do
    rescue_from 'Exception' do |exception|
      json_error(exception.message, 500, exception)
    end

    rescue_from 'UnauthorizedError' do |exception|
      json_error('unauthorized', 401, exception)
    end
  end

  def unauthorized!
    raise UnauthorizedError
  end

  private

  def json_error(text, status, exception)
    data = { error: text }
    data[:stacktrace] = exception&.backtrace&.first(20) if Rails.env.development? || Rails.env.test?
    render json: data, status: status
  end
end
