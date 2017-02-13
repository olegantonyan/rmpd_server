class Api::BaseController < ActionController::API
  include Api::Concerns::Errors
  include Api::Concerns::Authenticatable

  before_action :set_paper_trail_whodunnit
  after_action :disable_caching, if: -> { Rails.env.development? }

  private

  def disable_caching
    headers['Last-Modified'] = Time.zone.now.httpdate
  end
end
