class Api::BaseController < ActionController::API
  include Api::Concerns::Errors
  include Api::Concerns::Authenticatable

  before_action :set_paper_trail_whodunnit
end
