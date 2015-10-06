class Playlist::Item::Advertising < Playlist::Item
  with_options presence: true do
    validates :begin_time
    validates :end_time
    validates :playbacks_per_day
    validates :begin_date #TODO valid time and date
    validates :end_date
  end
  validate :media_item_type

  private

  def media_item_type
    errors.add(:media_item, "must be advertising type, got #{media_item.type}") unless media_item.advertising?
  end
end
