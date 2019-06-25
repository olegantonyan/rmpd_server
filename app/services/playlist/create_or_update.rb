class Playlist
  class CreateOrUpdate
    include ActiveModel::Model
    include ActiveModel::Validations

    using Typerb

    attr_reader :playlist, :params

    delegate :schedule, :playlist_items_advertising, :to_s, to: :playlist, allow_nil: true

    def initialize(playlist, params)
      @playlist = playlist.type!(Playlist)
      @params = params.type!(Hash).deep_symbolize_keys
    end

    def call # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
      ActiveRecord::Base.transaction do
        create_update_attributes
        added_media_items = create_update_playlist_items
        midnight_rollover
        validate_overlapped_schedule
        update_schedule
        notify_devices(added_media_items)
      end
      playlist
    rescue StandardError => e
      playlist.errors.each do |k, v|
        errors.add(k, v)
      end
      errors.add(:base, e.to_s)
      nil
    end

    private

    def create_update_attributes # rubocop: disable Metrics/AbcSize
      playlist.name = params[:name] if params[:name]
      playlist.description = params[:description] if params[:description]
      playlist.company_id = params[:company_id] if params[:company_id]
      playlist.shuffle = params[:shuffle] if params[:shuffle]
      playlist.save!
    end

    def create_update_playlist_items # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
      items_ids_in_playlist = playlist.playlist_items.pluck(:id)
      items_to_be_updated = params[:playlist_items].reject { |i| i[:id].nil? }

      items_ids_to_remove = items_ids_in_playlist - items_to_be_updated.map { |i| i[:id] }
      playlist.playlist_items.where(id: items_ids_to_remove).destroy_all

      attrs_bg = %i[media_item_id begin_date end_date begin_time end_time position wait_for_the_end]
      attrs_ad = %i[media_item_id begin_date end_date begin_time end_time playbacks_per_day wait_for_the_end]

      items_to_be_updated.each do |i|
        if i[:type] == 'background'
          playlist.playlist_items_background.find(i[:id]).update(i.slice(*attrs_bg))
        elsif i[:type] == 'advertising'
          playlist.playlist_items_advertising.find(i[:id]).update(i.slice(*attrs_ad))
        else
          raise ArgumentError, "unknown type `#{i[:type]}`"
        end
      end

      new_items_to_create = params[:playlist_items].select { |i| i[:id].nil? }
      new_items_to_create.map do |i|
        if i[:type] == 'background'
          playlist.playlist_items_background.create!(i.slice(*attrs_bg))
        elsif i[:type] == 'advertising'
          playlist.playlist_items_advertising.create!(i.slice(*attrs_ad))
        else
          raise ArgumentError, "unknown type `#{i[:type]}`"
        end.media_item
      end
    end

    def midnight_rollover
      playlist.playlist_items_background.begin_time_greater_than_end_time.find_each do |i|
        next_day = i.dup
        next_day.begin_time = midnight
        next_day.end_date += 1.day if next_day.end_date
        i.end_time = second_before_midnight
        i.wait_for_the_end = true
        i.save!
        next_day.save!
      end
    end

    def validate_overlapped_schedule
      raise 'advertising schedule overlap' unless schedule.valid?
    end

    def update_schedule # rubocop: disable Metrics/AbcSize
      qry = playlist_items_advertising.each_with_object({}) do |pitem, obj|
        scheduled_items = schedule.items.select { |i| i.id == pitem.id }
        intervals = scheduled_items.each_with_object([]) do |sitem, ary|
          ary << { date_interval: { begin: sitem.begin_date, end: sitem.end_date }, schedule: sitem.schedule }
        end
        obj[pitem.id] = { schedule: intervals }
      end
      playlist_items_advertising.update(qry.keys, qry.values)
    end

    def notify_devices(added_media_items)
      playlist.devices.each do |d|
        assignment = Playlist::Assign.new(assignable: d, playlist_id: playlist.id, force: true, added_media_items: added_media_items)
        raise assignment.errors.full_messages.to_sentence unless assignment.call
      end
    end

    def midnight
      Time.zone.parse('00:00:00').to_formatted_s(:rmpd_custom)
    end

    def second_before_midnight
      Time.zone.parse('23:59:59').to_formatted_s(:rmpd_custom)
    end
  end
end
