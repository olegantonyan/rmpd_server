class ErrorsController < BaseController
  include Gaffe::Errors if defined?(Gaffe)

  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  layout 'application'

  def show
    render "errors/#{@status_code}", status: @status_code
  end
end
