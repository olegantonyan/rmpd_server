class Device
  class Group
    class Membership < ApplicationRecord
      with_options inverse_of: :device_group_memberships do |a|
        a.belongs_to :device
        a.belongs_to :device_group, class_name: 'Device::Group'
      end

      with_options presence: true do
        validates :device
        validates :device_group
      end

      def to_s
        "#{device} @ #{device_group}"
      end
    end
  end
end
