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
      raise ActiveRecord::RecordInvalid unless playlist.save
      validate_overlapped_schedule
      update_schedule
    end
    true
  rescue ActiveRecord::RecordInvalid
    copy_errors(playlist)
    false
  end

  private

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
