class Playlist
  class Item
    class Advertising < Playlist::Item
      belongs_to :playlist, inverse_of: :playlist_items_advertising

      validates :begin_time, presence: true
      validates :end_time, presence: true
      validates :playbacks_per_day, presence: true, numericality: { greater_than_or_equal_to: 1 }
      validates :begin_date, presence: true
      validates :end_date, presence: true
      validate :media_item_type
      validate :fit_to_time_period
      validate :begin_time_less_than_end_time

      def playbacks_per_hour
        return 0 if begin_time.nil? || end_time.nil? || playbacks_per_day.nil?
        playbacks_per_day / ((end_time - begin_time) / 1.hour).round
      rescue StandardError
        0
      end

      private

      def media_item_type
        errors.add(:media_item, "must be advertising type, got #{media_item.type}") unless media_item.advertising?
      end

      def fit_to_time_period
        return if begin_time.nil? || end_time.nil? || !media_item.advertising?
        errors.add(:playbacks_per_day, "does not fit total playback time (#{total_time} sec)") if playback_duration >= total_time.seconds
      end

      def playback_duration
        media_item.duration * playbacks_per_day.to_i
      end

      def total_time
        end_time.to_time.utc - begin_time.to_time.utc
      end

      def begin_time_less_than_end_time
        return if begin_time.nil? || end_time.nil?
        errors.add(:begin_time, "#{begin_time.to_formatted_s(:rmpd_custom)} >= end time #{end_time.to_formatted_s(:rmpd_custom)}") if begin_time >= end_time
      end
    end
  end
end
