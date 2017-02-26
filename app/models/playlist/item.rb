class Playlist::Item < ApplicationRecord
  has_paper_trail

  with_options inverse_of: :playlist_items do |a|
    a.belongs_to :media_item
  end

  belongs_to :playlist

  with_options presence: true do
    validates :media_item
    validates :playlist
    validates :show_duration, numericality: { greater_than_or_equal_to: 1, less_than: 86_400 }, if: 'image?'
  end
  validate :check_files_processing
  validate :begin_date_less_than_end_date

  scope :with_media_item_type, ->(tp) { joins(:media_item).where('media_items.type = ?', MediaItem.types[tp.to_s]) }
  scope :background, -> { with_media_item_type('background') }
  scope :advertising, -> { with_media_item_type('advertising') }
  scope :begin_time_greater_than_end_time, -> { where('begin_time > end_time') }
  scope :search_query, ->(query) {
    q = "%#{query}%"
    joins(:media_item).where('LOWER(media_items.file) LIKE LOWER(?) OR LOWER(media_items.description) LIKE LOWER(?)', q, q)
  }

  with_options to: :media_item do
    delegate :file_url, :type, :description, :file_identifier, :background?, :advertising?, :duration, :content_type
    delegate :image?, allow_nil: true
  end

  serialize :schedule

  def to_s
    "#{media_item} @ #{playlist}"
  end

  def self.policy_class
    Playlist::ItemPolicy
  end

  def show_duration=(arg)
    super if image?
  end

  private

  def check_files_processing
    return unless media_item
    errors.add(:media_item, I18n.t('activerecord.attributes.media_item.file_processing')) if media_item.file_processing? || media_item.file_processing_failed?
    errors.add(:media_item, 'file processing failed') if media_item.file_processing_failed?
  end

  def begin_date_less_than_end_date
    return if begin_date.nil? || end_date.nil?
    errors.add(:begin_date, "#{begin_date.to_formatted_s(:rmpd_custom_date)} > end date #{end_date.to_formatted_s(:rmpd_custom_date)}") if begin_date > end_date
  end
end
