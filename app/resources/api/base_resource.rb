class Api::BaseResource < JSONAPI::Resource
  abstract

  attributes :created_at, :updated_at

  attr_reader :model
end
