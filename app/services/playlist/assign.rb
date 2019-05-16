class Playlist
  class Assign
    using ::Typerb

    include ActiveModel::Model
    include ActiveModel::Validations
    include ActionView::Helpers::NumberHelper

    class NotEnoughSpaceError < RuntimeError; end

    attr_reader :playlist_id, :assignable, :force

    validates :assignable, presence: true

    def initialize(playlist_id:, assignable:, force: false, added_media_items: [])
      @playlist_id = playlist_id.type!(Integer, String)
      @assignable = assignable.type!(Device, Device::Group)
      @force = force.type!(TrueClass, FalseClass)
      @added_media_items = added_media_items.type!(Array)
      @notifications = []
    end

    def call
      return false unless valid?
      ActiveRecord::Base.transaction do
        perform!
      end
      notify_all
      true
    rescue StandardError => e
      errors.add(:base, e.to_s)
      false
    end

    def to_s
      "#{playlist} to #{assignable}"
    end

    private

    attr_reader :notifications, :added_media_items

    def playlist
      Playlist.find_by(id: playlist_id)
    end

    def assign_to_device!(device)
      check_free_space!(device)
      device.playlist = playlist
      notify = device.playlist_id_changed? || force
      device.save! if device.changed?
      return unless notify
      command = device.playlist.present? ? :update_playlist : :delete_playlist
      notifications << { device: device, command: command }
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

      size_of_new_items = new_items_to_download(device).inject(0) { |acc, elem| acc + elem.size.to_i }
      msg = I18n.t('playlist_assign.free_space_error', device: device.to_s, free_space: number_to_human_size(free_space), size_of_new_items: number_to_human_size(size_of_new_items))
      raise NotEnoughSpaceError, msg if free_space < size_of_new_items + 10_000_000
    end

    def new_items_to_download(device) # rubocop: disable Metrics/AbcSize
      return [] unless playlist
      return playlist.media_items.to_a unless device.playlist

      if device.playlist_id == playlist.id
        added_media_items
      else
        playlist.media_items.where.not(id: device.playlist.media_items.pluck(:id)).to_a.uniq
      end
    end

    def notify_all
      notifications.each { |n| Deviceapi::Sender.new(n[:device]).send(n[:command]) }
    end
  end
end
