class Playlist::Creation < BaseService
  attr_accessor :playlist
  with_options to: :playlist, allow_nil: true do
    delegate :schedule, :playlist_items_advertising, :to_s
  end

  def self.model_name
    Playlist.model_name
  end

  def self.policy_class
    PlaylistPolicy
  end

  def save
    ActiveRecord::Base.transaction do
      playlist.save!
      midnight_rollover
      validate_overlapped_schedule
      update_schedule
    end
    true
  rescue ActiveRecord::RecordInvalid
    copy_errors(playlist)
    false
  end

  private

  # rubocop: disable Metrics/AbcSize
  def midnight_rollover
    playlist.playlist_items_background.begin_time_greater_than_end_time.find_each do |i|
      next_day = i.dup
      next_day.begin_time = Time.zone.parse('00:00:00').to_formatted_s(:rmpd_custom)
      next_day.end_date += 1.day if next_day.end_date
      i.end_time = Time.zone.parse('23:59:59').to_formatted_s(:rmpd_custom)
      i.save!
      next_day.save!
    end
  end
  # rubocop: enable Metrics/AbcSize

  def validate_overlapped_schedule
    overlap = schedule.overlap
    return if overlap.blank?
    errors.add(:base, "advertising schedule overlap: #{overlap.map(&:file_identifier).to_sentence}")
    raise ActiveRecord::RecordInvalid
  end

  # rubocop: disable Metrics/AbcSize
  def update_schedule
    qry = playlist_items_advertising.each_with_object({}) do |pitem, obj|
      scheduled_items = schedule.items.select { |i| i.id == pitem.id }
      intervals = scheduled_items.each_with_object([]) do |sitem, ary|
        ary << { date_interval: { begin: sitem.begin_date, end: sitem.end_date }, schedule: sitem.schedule }
      end
      obj[pitem.id] = { schedule: intervals }
    end
    playlist_items_advertising.update(qry.keys, qry.values)
  end
  # rubocop: enable Metrics/AbcSize
end
