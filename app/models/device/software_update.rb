class Device::SoftwareUpdate < ApplicationModel
  extend CarrierWave::Mount
  include Deviceapi::Sender

  attr_accessor :device, :distribution

  mount_uploader :distribution, SoftwareUpdateUploader

  with_options presence: true do
    validates :device
    validates :distribution
  end

  delegate :id, to: :device, allow_nil: true

  def save
    return false unless valid?
    store_distribution!
    send_to_device(:update_software, device, distribution_url: distribution_url)
    true
  end

  def supported?
    return false unless device
    rmpd_version = device.device_status.client_version.split(' ')[1]
    Gem::Version.new(rmpd_version) >= Gem::Version.new('0.4.16')
  end
end
