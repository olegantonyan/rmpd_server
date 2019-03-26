class Playlist
  class Item < ApplicationRecord
    class << self
      def policy_class
        Playlist::ItemPolicy
      end
    end

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

    delegate :file_url, :type, :description, :file_identifier, :background?, :advertising?, :duration, :content_type, to: :media_item

    serialize :schedule

    def to_s
      "#{media_item} @ #{playlist}"
    end

    private

    def begin_date_less_than_end_date
      return if begin_date.nil? || end_date.nil?
      errors.add(:begin_date, "#{begin_date.to_formatted_s(:rmpd_custom_date)} > end date #{end_date.to_formatted_s(:rmpd_custom_date)}") if begin_date > end_date
    end
  end
end
