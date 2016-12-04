class Api::PlaylistResource < Api::BaseResource
  attributes :name, :description, :shuffle

  has_one :company
end
