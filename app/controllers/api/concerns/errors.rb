module Api::Concerns::Errors
  extend ActiveSupport::Concern

  class UnauthorizedError < RuntimeError; end

  included do
    rescue_from 'Exception' do |exception|
      json_error(exception, 500)
    end

    rescue_from 'UnauthorizedError' do |exception|
      json_error(exception, 401)
    end
  end

  def unauthorized!
    raise UnauthorizedError, 'unauthorized'
  end

  private

  def json_error(exception, status)
    data = { error: exception.message }
    data[:stacktrace] = exception.backtrace.first(20) if Rails.env.development? || Rails.env.test?
    render json: data, status: status
  end
end
