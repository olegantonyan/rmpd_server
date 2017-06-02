module Api::Concerns::AuthorizableResource
  extend ActiveSupport::Concern

  included do
    include JSONAPI::Authorization::PunditScopedResource

    attribute :acl
  end

  def acl
    policy = Pundit.policy!(context[:user], model)
    %i[show update destroy].each_with_object({}) do |e, a|
      a[e] = policy.public_send("#{e}?")
    end
  end
end
