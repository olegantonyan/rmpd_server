module Playlist::ItemsCreation
  extend ActiveSupport::Concern

  included do
    before_validation :create_playlist_items_background, if: -> {
      !playlist_items_background_created && media_items_background_ids && media_items_background_positions
    }
    attr_accessor :media_items_background_ids
    attr_accessor :media_items_background_positions

    before_validation :create_playlist_items_advertising, if: -> {
      !playlist_items_advertising_created && media_items_advertising_ids && media_items_advertising_begin_times && media_items_advertising_end_times && media_items_advertising_playbacks_totals
    }
    attr_accessor :media_items_advertising_ids
    attr_accessor :media_items_advertising_begin_times
    attr_accessor :media_items_advertising_end_times
    attr_accessor :media_items_advertising_playbacks_totals

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

      playlist_items << Playlist::Item::Background.new(media_item_id: i, position: position)
    end
    self.playlist_items_background_created = true
  end

  def create_playlist_items_advertising
    playlist_items.advertising.destroy_all
    media_items_advertising_ids.each do |i|
      begin_time = media_items_advertising_begin_times.find{ |k,v| k.to_i == i.to_i}.second
      end_time = media_items_advertising_end_times.find{ |k,v| k.to_i == i.to_i}.second
      playbacks_total = media_items_advertising_playbacks_totals.find{ |e| e.first.to_i == i.to_i}.second

      playlist_items << Playlist::Item::Advertising.new(media_item_id: i,
                                                        playbacks_total: playbacks_total,
                                                        begin_time: time_param_to_time(begin_time),
                                                        end_time: time_param_to_time(end_time))
    end
    self.playlist_items_advertising_created = true
  end

  def time_param_to_time(param)
    Time.zone.parse("#{param[:hour]}:#{param[:minute]}")
  end

end
