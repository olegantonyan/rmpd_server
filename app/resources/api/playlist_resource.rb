module Api
  class PlaylistResource < Api::BaseResource
    attributes :name, :description, :shuffle, :total_size, :media_items_count

    has_one :company
    has_many :devices
    has_many :playlist_items, class_name: 'PlaylistItem' # NOTE: PlaylistItem is a resource class

    def self.updatable_fields(context)
      super - %i[total_size media_items_count]
    end
  end
end
