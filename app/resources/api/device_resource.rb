class Api::DeviceResource < Api::BaseResource
  attributes :login, :name, :time_zone, :message_queue_sync_period, :wallpaper

  def self.status_attributes
    %i(online poweredon_at now_playing devicetime free_space)
  end

  attributes(*status_attributes)

  has_one :company
  has_one :playlist
  has_many :device_groups, class_name: 'DeviceGroup'

  def self.updatable_fields(context)
    super - %i(login) - status_attributes
  end

  status_attributes.each do |a|
    define_method(a) { model.device_status.public_send(a) }
  end

  def self.records(_options = {})
    super.ordered
  end
end
