class Device
  class Group
    class Membership < ApplicationRecord
      belongs_to :device, inverse_of: :device_group_memberships
      belongs_to :device_group, class_name: 'Device::Group', inverse_of: :device_group_memberships

      validates :device, presence: true
      validates :device_group, presence: true

      def to_s
        "#{device} @ #{device_group}"
      end
    end
  end
end
