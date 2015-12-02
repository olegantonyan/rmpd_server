class Playlist::Assignment
  include ActiveModel::Model
  include ActiveModel::Validations
  include Deviceapi::Sender

  attr_accessor :playlist_id, :assignable

  validates :assignable, presence: true

  # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      case assignable
      when Device
        assign_to_device!(assignable)
      when Device::Group
        assignable.devices.each { |device| assign_to_device!(device) }
      else
        fail ArgumentError, "unknown assignable type #{assignable.try(:class).try(:name)}"
      end
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.to_s)
    false
  end
  # rubocop: enable Metrics/AbcSize, Metrics/MethodLength

  def playlist
    @_playlist ||= Playlist.find_by_id(playlist_id)
  end

  def to_s
    "#{playlist} to #{assignable}"
  end

  private

  def assign_to_device!(device)
    device.playlist = playlist
    notify = device.playlist_id_changed?
    device.save!
    return unless notify
    command = device.playlist.present? ? :update_playlist : :delete_playlist
    send_to_device(command, device)
  end
end
