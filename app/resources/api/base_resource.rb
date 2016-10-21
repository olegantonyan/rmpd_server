class Api::BaseResource < JSONAPI::Resource
  abstract

  attributes :created_at, :updated_at
end
