module Api
  class DeviceGroupResource < Api::BaseResource
    model_name 'Device::Group'

    attributes :title

    has_many :devices
  end
end
