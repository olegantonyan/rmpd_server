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

  rails_admin do
    visible false
  end

  private

  def media_item_type
    errors.add(:media_item, "must be advertising type, got #{media_item.type}") unless media_item.advertising?
  end

  def begin_date_less_than_end_date
    return if begin_date.nil? || end_date.nil?
    errors.add(:begin_date, "#{begin_date} > end date #{end_date}") if begin_date > end_date
  end

  # rubocop: disable Metrics/AbcSize
  def fit_to_time_period
    return if begin_time.nil? || end_time.nil? || !media_item.advertising?
    errors.add(:playbacks_per_day, "does not fit total playback time (#{total_time} sec)") if playback_duration.total >= total_time.seconds
  end
  # rubocop: enable Metrics/AbcSize

  def playback_duration
    MediafilesUtils.duration(media_item.file_path) * playbacks_per_day.to_i
  end

  def total_time
    end_time - begin_time
  end
end
