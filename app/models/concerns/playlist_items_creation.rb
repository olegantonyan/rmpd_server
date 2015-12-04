module PlaylistItemsCreation
  extend ActiveSupport::Concern

  class_methods do
    def media_items_attrs
      [:media_items_background_ids,
       :media_items_background_positions,
       :media_items_background_begin_time,
       :media_items_background_end_time,
       :media_items_advertising_ids,
       :media_items_advertising_begin_times,
       :media_items_advertising_end_times,
       :media_items_advertising_playbacks_per_days,
       :media_items_advertising_begin_dates,
       :media_items_advertising_end_dates]
    end
  end

  included do
    media_items_attrs.each do |attr|
      attr_accessor attr
    end
    before_validation :create_playlist_items_background, if: '!playlist_items_background_created'
    before_validation :create_playlist_items_advertising, if: '!playlist_items_advertising_created'

    private

    attr_accessor :playlist_items_background_created
    attr_accessor :playlist_items_advertising_created
  end

  private

  def media_items_background_ids=(arg)
    super
    self.playlist_items_background_created = false
  end

  def media_items_advertising_ids=(arg)
    super
    self.playlist_items_advertising_created = false
  end

  # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
  def create_playlist_items_background
    self.media_items_background_ids ||= []
    playlist_items.background.destroy_all
    media_items_background_ids.each do |i|
      position = find_object(media_items_background_positions, i)

      playlist_items << Playlist::Item::Background.new(media_item_id: i,
                                                       position: position,
                                                       begin_time: time_param_to_time(media_items_background_begin_time),
                                                       end_time: time_param_to_time(media_items_background_end_time))
    end
    self.playlist_items_background_created = true
  end

  def create_playlist_items_advertising
    self.media_items_advertising_ids ||= []
    playlist_items.advertising.destroy_all
    media_items_advertising_ids.each do |i|
      begin_time = find_hash(media_items_advertising_begin_times, i)
      end_time = find_hash(media_items_advertising_end_times, i)
      playbacks_per_day = find_object(media_items_advertising_playbacks_per_days.find, i)
      begin_date = find_hash(media_items_advertising_begin_dates, i)
      end_date = find_hash(media_items_advertising_end_dates, i)

      playlist_items << Playlist::Item::Advertising.new(media_item_id: i,
                                                        playbacks_per_day: playbacks_per_day,
                                                        begin_time: time_param_to_time(begin_time),
                                                        end_time: time_param_to_time(end_time),
                                                        begin_date: date_param_to_date(begin_date),
                                                        end_date: date_param_to_date(end_date))
    end
    self.playlist_items_advertising_created = true
  end
  # rubocop: enable Metrics/AbcSize, Metrics/MethodLength

  def time_param_to_time(param)
    Time.zone.parse("#{param[:hour]}:#{param[:minute]}")
  end

  def date_param_to_date(param)
    Date.parse("#{param[:day]}.#{param[:month]}.#{param[:year]}")
  end

  def find_hash(arg, index)
    arg.find { |k, _| k.to_i == index.to_i }.second
  end

  def find_object(arg, index)
    arg.find { |e| e.first.to_i == index.to_i }.second
  end
end
