module Filterrificable
  extend ActiveSupport::Concern

  def on_reset
    skip_policy_scope
    skip_authorization
  end

  def per_page
    params[:per_page] || default_per_page
  end

  def page
    params[:page]
  end

  def default_per_page
    20
  end
end
