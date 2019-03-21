class Device
  class SoftwareUpdate < ActiveModelBase
    extend CarrierWave::Mount

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
      Deviceapi::Sender.new(device).send(:update_software, distribution_url: distribution_url)
      true
    end

    def supported?
      device&.client_version&.self_update_support?
    end
  end
end
