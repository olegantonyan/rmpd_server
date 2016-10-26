module Api::Concerns::AuthorizableResource
  extend ActiveSupport::Concern

  included do
    include JSONAPI::Authorization::PunditScopedResource
  end

  def meta(_options)
    acl = %i(show update destroy).each_with_object({}) do |e, a|
      a[e] = Pundit.policy!(context[:user], model).public_send("#{e}?")
    end
    { acl: acl }
  end
end
