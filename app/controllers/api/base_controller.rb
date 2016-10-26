class Api::BaseController < ActionController::API
  include Api::Concerns::Errors
  include Api::Concerns::Authenticatable
  include JSONAPI::ActsAsResourceController
  include Api::Concerns::Authorizable

  before_action :set_paper_trail_whodunnit
end
