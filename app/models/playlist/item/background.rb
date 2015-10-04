class Playlist::Item::Background < Playlist::Item
  validates :position, presence: true
  validates_inclusion_of :position, in: -1000000..1000000
  validate :media_item_type

  private

  def media_item_type
    errors.add(:media_item, "must be background type, got #{media_item.type}") unless media_item.background?
  end

end
