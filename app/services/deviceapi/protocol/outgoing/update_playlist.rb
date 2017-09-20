module Deviceapi
  module Protocol
    module Outgoing
      class UpdatePlaylist < Deviceapi::Protocol::Outgoing::BaseCommand
        def call(_options = {})
          return unless device.playlist
          clean_previous_commands
          enqueue(json)
        end

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
            total_size: playlist.total_size,
            items: playlist.playlist_items.includes(:media_item).map { |i| serialized_playlist_item(i) }
          }
        end

        # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
        def serialized_playlist_item(i)
          {
            url: i.file_url,
            filename: i.file_identifier,
            id: i.id,
            media_item_id: i.media_item_id,
            description: i.description,
            type: i.type,
            position: i.position,
            content_type: i.content_type,
            show_duration: i.show_duration,
            begin_time: i.begin_time&.strftime(time_format),
            end_time: i.end_time&.strftime(time_format),
            end_date: i.end_date&.strftime(date_format),
            begin_date: i.begin_date&.strftime(date_format),
            playbacks_per_day: i.playbacks_per_day,
            schedule_intervals: serialized_schedule(i),
            wait_for_the_end: i.wait_for_the_end,
            schedule: [] # legacy
          }
        end
        # rubocop: enable Metrics/AbcSize, Metrics/MethodLength

        def serialized_schedule(item)
          return [] unless item.advertising?
          return [] unless item.schedule
          item.schedule.map do |j|
            { date_interval: j[:date_interval], schedule: j[:schedule].map { |s| s.strftime(time_format) } }
          end
        end

        def time_format
          '%H:%M:%S'
        end

        def date_format
          '%d.%m.%Y'
        end

        def legacy_items
          items = []
          device.playlist.playlist_items.includes(:media_item).each { |d| items << d.media_item.file_url }
          items
        end

        def legacy_json
          {
            type: 'playlist',
            status: 'update',
            items: legacy_items # old implementation, for compatability
          }
        end
      end
    end
  end
end
