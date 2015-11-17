require 'playlist'
require 'playlist/item'
require 'playlist/item/advertising'
require 'playlist/item/background'

module Playlist::ItemsCreation
  extend ActiveSupport::Concern

  included do
    attr_accessor :media_items_background_ids
    attr_accessor :media_items_background_positions
    attr_accessor :media_items_background_begin_time
    attr_accessor :media_items_background_end_time
    before_validation :create_playlist_items_background, if: -> {
      !playlist_items_background_created &&
      media_items_background_ids
    }

    attr_accessor :media_items_advertising_ids
    attr_accessor :media_items_advertising_begin_times
    attr_accessor :media_items_advertising_end_times
    attr_accessor :media_items_advertising_playbacks_per_days
    attr_accessor :media_items_advertising_begin_dates
    attr_accessor :media_items_advertising_end_dates
    before_validation :create_playlist_items_advertising, if: -> {
      !playlist_items_advertising_created &&
      media_items_advertising_ids
    }

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

  def create_playlist_items_background
    playlist_items.background.destroy_all
    media_items_background_ids.each do |i|
      position = media_items_background_positions.find{ |e| e.first.to_i == i.to_i}.second

      playlist_items << Playlist::Item::Background.new(media_item_id: i,
                                                       position: position,
                                                       begin_time: time_param_to_time(media_items_background_begin_time),
                                                       end_time: time_param_to_time(media_items_background_end_time)
                                                       )
    end
    self.playlist_items_background_created = true
  end

  def create_playlist_items_advertising
    playlist_items.advertising.destroy_all
    media_items_advertising_ids.each do |i|
      begin_time = media_items_advertising_begin_times.find{ |k,v| k.to_i == i.to_i}.second
      end_time = media_items_advertising_end_times.find{ |k,v| k.to_i == i.to_i}.second
      playbacks_per_day = media_items_advertising_playbacks_per_days.find{ |e| e.first.to_i == i.to_i}.second
      begin_date = media_items_advertising_begin_dates.find{ |k,v| k.to_i == i.to_i}.second
      end_date = media_items_advertising_end_dates.find{ |k,v| k.to_i == i.to_i}.second

      playlist_items << Playlist::Item::Advertising.new(media_item_id: i,
                                                        playbacks_per_day: playbacks_per_day,
                                                        begin_time: time_param_to_time(begin_time),
                                                        end_time: time_param_to_time(end_time),
                                                        begin_date: date_param_to_date(begin_date),
                                                        end_date: date_param_to_date(end_date)
                                                        )
    end
    self.playlist_items_advertising_created = true
  end

  def time_param_to_time(param)
    Time.zone.parse("#{param[:hour]}:#{param[:minute]}")
  end

  def date_param_to_date(param)
    Date.parse("#{param[:day]}.#{param[:month]}.#{param[:year]}")
  end

end
