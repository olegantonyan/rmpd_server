module Filterrificable
  extend ActiveSupport::Concern

  def on_reset
    skip_policy_scope
    skip_authorization
  end

end
