class Device
  class Status < ApplicationRecord
    belongs_to :device, inverse_of: :device_status

    validates :now_playing, length: { maximum: 1024 }

    scope :online, -> { where(online: true) }

    delegate :client_version, to: :device, allow_nil: true

    def to_s
      "#{device} #{online ? 'online' : 'offline'}"
    end
  end
end
