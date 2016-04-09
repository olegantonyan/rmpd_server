class Playlist::Item::Background < Playlist::Item
  with_options presence: true do
    validates :begin_time
    validates :end_time
    validates :position, inclusion: { in: -1_000_000..1_000_000 }
  end
  validate :media_item_type

  private

  def media_item_type
    errors.add(:media_item, "must be background type, got #{media_item.type}") unless media_item.background?
  end
end
