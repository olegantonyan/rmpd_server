class Device
  class SoftwareUpdate
    attr_accessor :device, :distribution

    def save
      Deviceapi::Sender.new(device).send(:update_software, distribution_url: distribution_url)
    end

    def supported?
      device&.client_version&.self_update_support?
    end
  end
end
