class Playlist
  class Item
    class Background < Playlist::Item
      belongs_to :playlist, inverse_of: :playlist_items_background

      validates :begin_time, presence: true
      validates :end_time, presence: true
      validates :position, presence: true, inclusion: { in: -1_000_000..1_000_000 }
      validate :media_item_type

      private

      def media_item_type
        errors.add(:media_item, "must be background type, got #{media_item.type}") unless media_item.background?
      end
    end
  end
end
