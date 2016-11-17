class Api::BaseJsonapiController < Api::BaseController
  include JSONAPI::ActsAsResourceController
  include Api::Concerns::Authorizable
end
