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
    return unless overlap
    errors.add(:base, "advertising schedule overlap: #{overlap.map(&:file_identifier).to_sentence}")
    raise ActiveRecord::RecordInvalid
  end

  def update_schedule
    playlist_items_advertising.each do |pitem|
      pitem.schedule = schedule.items.find { |i| i.id == pitem.id }.schedule_times
      pitem.save!
    end
  end
end
