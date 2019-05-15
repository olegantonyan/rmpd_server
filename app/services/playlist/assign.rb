class Playlist
  class Assign
    include ActiveModel::Model
    include ActiveModel::Validations

    class NotEnoughSpaceError < RuntimeError; end

    attr_accessor :playlist, :assignable, :force

    validates :assignable, presence: true

    def call
      return false unless valid?
      @notifications ||= []
      ActiveRecord::Base.transaction do
        perform!
      end
      notify_all
      true
    rescue ActiveRecord::RecordInvalid, NotEnoughSpaceError => e
      errors.add(:base, e.to_s)
      false
    end

    def to_s
      "#{playlist} to #{assignable}"
    end

    private

    def assign_to_device!(device)
      check_free_space!(device)
      device.playlist = playlist
      notify = device.playlist_id_changed? || force
      device.save! if device.changed?
      return unless notify
      command = device.playlist.present? ? :update_playlist : :delete_playlist
      @notifications << { device: device, command: command }
    end

    def perform!
      case assignable
      when Device
        assign_to_device!(assignable)
      when Device::Group
        assignable.devices.each do |device|
          assign_to_device!(device)
        end
      else
        raise ArgumentError, "unknown assignable type #{assignable&.class&.name}"
      end
    end

    def check_free_space!(device)
      free_space = device&.free_space
      return unless free_space
      return if free_space.zero?
      size_of_new_items = new_items_to_download(device).inject(0) { |acc, elem| acc + elem.file.size.to_i }
      msg = "Device #{device} has not enough free space (#{free_space}) to update playlist (requires #{size_of_new_items})"
      raise NotEnoughSpaceError, msg if free_space < size_of_new_items + 10_000_000
    end

    # rubocop: disable Metrics/AbcSize
    def new_items_to_download(device)
      return [] unless playlist
      return playlist.uniq_media_items.to_a unless device.playlist
      if device.playlist_id == playlist.id
        playlist.added_playlist_items.map(&:media_item)
      else
        playlist.media_items.where.not(id: device.playlist.media_items.pluck(:id)).to_a.uniq
      end
    end
    # rubocop: enable Metrics/AbcSize

    def notify_all
      @notifications.each { |n| Deviceapi::Sender.new(n[:device]).send(n[:command]) }
    end
  end
end
