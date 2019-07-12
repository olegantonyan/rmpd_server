class Playlist
  class Item < ApplicationRecord
    belongs_to :media_item, inverse_of: :playlist_items
    belongs_to :playlist

    validates :media_item, presence: true
    validates :playlist, presence: true
    validate :begin_date_less_than_end_date

    scope :with_media_item_type, ->(tp) { joins(:media_item).where('media_items.type = ?', MediaItem.types[tp.to_s]) }
    scope :background, -> { with_media_item_type('background') }
    scope :advertising, -> { with_media_item_type('advertising') }
    scope :begin_time_greater_than_end_time, -> { where('begin_time > end_time') }
    scope :search_query, ->(query) {
      q = "%#{query}%"
      joins(:media_item).where('LOWER(media_items.file) LIKE LOWER(?) OR LOWER(media_items.description) LIKE LOWER(?)', q, q)
    }

    delegate :file_url, :type, :description, :file_name, :background?, :advertising?, :duration, :content_type, to: :media_item

    def to_s
      "#{media_item} @ #{playlist}"
    end

    def serialize
      i = attributes.except('media_item_id', 'playlist_id', 'created_at', 'updated_at', 'begin_time', 'end_time', 'begin_date', 'end_date')
      i['type'] = type
      i['begin_time'] = begin_time&.to_formatted_s(:rmpd_custom)
      i['end_time'] = end_time&.to_formatted_s(:rmpd_custom)
      i['begin_date'] = begin_date&.to_formatted_s(:rmpd_custom_date)
      i['end_date'] = end_date&.to_formatted_s(:rmpd_custom_date)
      i['media_item'] = media_item.serialize
      i
    end

    private

    def begin_date_less_than_end_date
      return if begin_date.nil? || end_date.nil?
      errors.add(:begin_date, "#{begin_date.to_formatted_s(:rmpd_custom_date)} > end date #{end_date.to_formatted_s(:rmpd_custom_date)}") if begin_date > end_date
    end
  end
end
