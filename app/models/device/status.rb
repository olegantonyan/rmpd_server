class Device::Status < ApplicationRecord
  belongs_to :device, inverse_of: :device_status

  validates :now_playing, length: { maximum: 1024 }

  scope :online, -> { where(online: true) }

  def to_s
    "#{device} #{online ? 'online' : 'offline'}"
  end

  def client_version
    device.device_log_messages.latest&.user_agent
  end
end
