class Playlist::Item < ActiveRecord::Base
  has_paper_trail

  with_options inverse_of: :playlist_items do |a|
    a.belongs_to :media_item
    a.belongs_to :playlist
  end

  with_options presence: true do
    validates :media_item
    validates :playlist
  end
  validate :check_files_processing
  validate :begin_time_less_than_end_time

  scope :background, -> { joins(:media_item).where('media_items.type = ?', MediaItem.types['background']) }
  scope :advertising, -> { joins(:media_item).where('media_items.type = ?', MediaItem.types['advertising']) }

  delegate :file_url, :type, :description, :file_identifier, :background?, :advertising?, to: :media_item

  rails_admin do
    visible false
  end

  def to_s
    "#{media_item} @ #{playlist}"
  end

  private

  def check_files_processing
    errors.add(:media_item, I18n.t('activerecord.attributes.media_item.file_processing')) if media_item.file.video? && media_item.file_processing?
  end

  def begin_time_less_than_end_time
    return if begin_time.nil? || end_time.nil?
    errors.add(:begin_time, "#{begin_time} >= end time #{end_time}") if begin_time >= end_time
  end
end
