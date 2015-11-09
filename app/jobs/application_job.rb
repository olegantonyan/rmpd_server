class ApplicationJob < ActiveJob::Base
  include Rails.application.routes.url_helpers

  protected

  def default_url_options
    ActionMailer::Base.default_url_options
  end
end
