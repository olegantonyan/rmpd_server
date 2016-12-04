class Api::BaseJsonapiController < Api::BaseController
  include JSONAPI::ActsAsResourceController

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    head :forbidden
  end

  def context
    { user: current_user }
  end

  def base_meta
    model_class = JSONAPI::Resource.resource_for(params[:controller])._model_class
    policy = Pundit.policy!(context[:user], model_class)
    acl = %i(create index).each_with_object({}) do |e, a|
      a[e] = policy.public_send("#{e}?")
    end
    super.merge(acl: acl)
  end
end
