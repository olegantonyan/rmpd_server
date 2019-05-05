class Playlist
  class CreateOrUpdate
    include ActiveModel::Model
    include ActiveModel::Validations

    using Typerb

    attr_reader :playlist, :params

    delegate :schedule, :playlist_items_advertising, :to_s, to: :playlist, allow_nil: true

    def initialize(playlist, params)
      @playlist = playlist.type!(Playlist)
      @params = params.type!(Hash, ActionController::Parameters)
    end

    def call # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
      ActiveRecord::Base.transaction do
        assign_attributes
        assign_playlist_items
        playlist.save!
        midnight_rollover
        validate_overlapped_schedule
        update_schedule
        notify_devices
      end
      playlist
    rescue ActiveRecord::RecordInvalid
      playlist.errors.each do |k, v|
        errors.add(k, v)
      end
      nil
    end

    private

    def assign_attributes # rubocop: disable Metrics/AbcSize
      playlist.name = params[:name] if params[:name]
      playlist.description = params[:description] if params[:description]
      playlist.company_id = params[:company_id] if params[:company_id]
      playlist.shuffle = params[:shuffle] if params[:shuffle]
    end

    def assign_playlist_items
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
      overlap = schedule.overlap
      return if overlap.blank?
      errors.add(:base, "advertising schedule overlap: #{overlap.map(&:file_name).to_sentence}")
      raise ActiveRecord::RecordInvalid
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

    def notify_devices
      playlist.devices.each do |d|
        # assignment = Playlist::Assignment.new(assignable: d, playlist: playlist, force: true)
        # unless assignment.save
        #   errors.add(:base, assignment.errors.full_messages.to_sentence)
        #   raise ActiveRecord::RecordInvalid
        # end
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
