class Playlist::Item::Background < Playlist::Item
  validates :position, presence: true
  validates :position, inclusion: { in: -1_000_000..1_000_000 }
  validate :media_item_type

  private

  def media_item_type
    errors.add(:media_item, "must be background type, got #{media_item.type}") unless media_item.background?
  end
end
