class Api::PlaylistResource < Api::BaseResource
  attributes :name, :description, :shuffle, :total_size, :media_items_count

  has_one :company
  has_many :devices

  def self.updatable_fields(context)
    super - %i(total_size media_items_count)
  end
end
