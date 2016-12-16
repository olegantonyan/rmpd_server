class Api::DeviceResource < Api::BaseResource
  attributes :login, :name, :time_zone, :message_queue_sync_period, :wallpaper

  has_one :company
  has_one :playlist
  has_many :device_groups, class_name: 'DeviceGroup'

  def self.updatable_fields(context)
    super - %i(login)
  end
end
