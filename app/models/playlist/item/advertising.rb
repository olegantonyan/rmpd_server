class Playlist::Item::Advertising < Playlist::Item
  with_options presence: true do
    validates :begin_time
    validates :end_time
    validates :playbacks_per_day
    validates :begin_date
    validates :end_date
  end
  validate :media_item_type
  validate :begin_date_less_than_end_date
  validate :fit_to_time_period

  private

  def media_item_type
    errors.add(:media_item, "must be advertising type, got #{media_item.type}") unless media_item.advertising?
  end

  def begin_date_less_than_end_date
    errors.add(:begin_date, "#{begin_date} > end date #{end_date}") if begin_date > end_date
  end

  def fit_to_time_period
    #TODO calculate  playbacks_per_day * overal time ...
  end
end
