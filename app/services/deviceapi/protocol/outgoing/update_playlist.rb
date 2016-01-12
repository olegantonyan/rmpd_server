class Deviceapi::Protocol::Outgoing::UpdatePlaylist < Deviceapi::Protocol::Outgoing::BaseCommand
  # rubocop: disable Lint/UnusedMethodArgument
  def call(options = {})
    return unless device.playlist
    clean_previous_commands
    enqueue(json)
  end
  # rubocop: enable Lint/UnusedMethodArgument

  private

  def json
    {
      playlist: serialized_playlist(device.playlist)
    }.merge(legacy_json)
  end

  def serialized_playlist(playlist)
    {
      name: playlist.name,
      description: playlist.description,
      created_at: playlist.created_at,
      updated_at: playlist.updated_at,
      shuffle: playlist.shuffle,
      items: playlist.playlist_items.includes(:media_item).map { |i| serialized_media_item(i) }
    }
  end

  # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
  def serialized_media_item(i)
    {
      url: i.file_url,
      filename: i.file_identifier,
      id: i.media_item_id,
      description: i.description,
      type: i.type,
      position: i.position,
      begin_time: i.begin_time.try(:strftime, time_format),
      end_time: i.end_time.try(:strftime, time_format),
      end_date: i.end_date.try(:strftime, date_format),
      begin_date: i.begin_date.try(:strftime, date_format),
      playbacks_per_day: i.playbacks_per_day,
      schedule: serialized_schedule(i)
    }
  end
  # rubocop: enable Metrics/AbcSize, Metrics/MethodLength

  def serialized_schedule(item)
    return [] unless item.advertising?
    return [] unless item.schedule
    item.schedule.map { |j| j.strftime(time_format) }
  end

  def legacy_items
    items = []
    device.playlist.playlist_items.includes(:media_item).each { |d| items << d.media_item.file_url }
    # device.playlist.media_items.each {|i| items << i.file_url } # TODO: fix this fucking problem
    p = Playlist.find(device.playlist.id) # NOTE: http://stackoverflow.com/questions/26923249/rails-carrierwave-manual-file-upload-wrong-url
    items << p.file_url
    items
  end

  def legacy_json
    {
      type: 'playlist',
      status: 'update',
      items: legacy_items # old implementation, for compatability
    }
  end

  def time_format
    '%H:%M:%S'.freeze
  end

  def date_format
    '%d.%m.%Y'.freeze
  end
end
