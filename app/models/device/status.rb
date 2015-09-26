class Device::Status < ActiveRecord::Base
  belongs_to :device, inverse_of: :device_status

  validates_length_of :now_playing, maximum: 1024

  scope :online, -> { where(online: true) }

  rails_admin do
    visible false
  end

  def to_s
    "#{device.to_s} #{online ? 'online' : 'offline'}"
  end

end
