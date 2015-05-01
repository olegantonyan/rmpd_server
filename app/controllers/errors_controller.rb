class ErrorsController < UsersApplicationController
  include Gaffe::Errors
  
  skip_before_filter :authenticate_user!
  layout 'application'
  
  def show
    render "errors/#{@status_code}", status: @status_code
  end
  
end
