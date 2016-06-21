class Playlist::Item < ApplicationRecord
  has_paper_trail

  with_options inverse_of: :playlist_items do |a|
    a.belongs_to :media_item
  end

  belongs_to :playlist

  with_options presence: true do
    validates :media_item
    validates :playlist
  end
  validate :check_files_processing
  validate :begin_time_less_than_end_time
  validate :begin_date_less_than_end_date

  scope :background, -> { joins(:media_item).where('media_items.type = ?', MediaItem.types['background']) }
  scope :advertising, -> { joins(:media_item).where('media_items.type = ?', MediaItem.types['advertising']) }

  delegate :file_url, :type, :description, :file_identifier, :background?, :advertising?, :duration, to: :media_item

  serialize :schedule

  def to_s
    "#{media_item} @ #{playlist}"
  end

  def self.policy_class
    Playlist::ItemPolicy
  end

  private

  def check_files_processing
    return unless media_item
    errors.add(:media_item, I18n.t('activerecord.attributes.media_item.file_processing')) if media_item.file_processing?
  end

  def begin_time_less_than_end_time
    return if begin_time.nil? || end_time.nil?
    errors.add(:begin_time, "#{begin_time} >= end time #{end_time}") if begin_time >= end_time
  end

  def begin_date_less_than_end_date
    return if begin_date.nil? || end_date.nil?
    errors.add(:begin_date, "#{begin_date} > end date #{end_date}") if begin_date > end_date
  end
end
