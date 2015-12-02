class ErrorsController < BaseController
  include Gaffe::Errors

  skip_before_action :authenticate_user!
  layout 'application'

  def show
    render "errors/#{@status_code}", status: @status_code
  end
end
