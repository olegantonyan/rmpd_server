class Api::BaseResource < JSONAPI::Resource
  include Api::Concerns::AuthorizableResource

  abstract

  attributes :created_at, :updated_at

  attr_reader :model

  def self.updatable_fields(context)
    super - %i(created_at updated_at id acl)
  end

  def self.creatable_fields(context)
    updatable_fields(context)
  end
end
