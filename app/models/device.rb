class Device < ApplicationRecord
  has_secure_password

  has_many :device_group_memberships, class_name: 'Device::Group::Membership', inverse_of: :device, dependent: :destroy
  has_many :device_groups, through: :device_group_memberships, class_name: 'Device::Group'
  has_many :device_log_messages, class_name: 'Device::LogMessage', inverse_of: :device, dependent: :destroy
  belongs_to :playlist, inverse_of: :devices, optional: true
  belongs_to :company, optional: true, inverse_of: :devices
  has_many :device_software_updates, class_name: 'Device::SoftwareUpdate', dependent: :destroy

  validates :login, presence: true, uniqueness: true, length: { in: 4..100 }
  validates :password, presence: true, length: { in: 8..60 }, confirmation: true, if: -> { new_record? || !password.nil? }
  validates :name, length: { maximum: 40 }

  after_destroy { send_to(:clear_queue) }
  after_commit(on: :update) { DevicesChannel.broadcast_to(self, serialize) }

  scope :search_query, ->(query) {
    q = "%#{query}%"
    where('LOWER(devices.name) LIKE LOWER(?) OR LOWER(devices.login) LIKE LOWER(?)', q, q)
  }
  scope :with_company_id, ->(ids) { where(company_id: [*ids].map { |i| ['null', 'nil', ''].include?(i) ? nil : i }) }
  scope :with_device_group_id, ->(ids) { joins(:device_groups).where(device_groups: { id: [*ids] }) }
  scope :ordered_by_online, ->(direction = :desc) { order(online: direction) }
  scope :online, -> { where(online: true) }

  def to_s
    if name.blank?
      login
    else
      "#{login} (#{name})"
    end
  end

  def time_zone_formatted_offset
    tz = time_zone.presence || Rails.application.config.time_zone
    ActiveSupport::TimeZone.new(tz).formatted_offset
  end

  def time_zone_formatted_tzinfo
    tz = time_zone.presence || Rails.application.config.time_zone
    ActiveSupport::TimeZone.new(tz).tzinfo.name
  end

  def synchronizing?
    Deviceapi::MessageQueue.find_by(key: login)
  end

  def bound_to_company?
    company.present?
  end

  def client_version
    ClientVersion.new(device_log_messages.latest&.user_agent)
  end

  def send_to(command, options = {})
    Deviceapi::Sender.new(self).send(command, options)
  end

  def serialize
    d = attributes.slice('id', 'login', 'name', 'created_at', 'updated_at', 'time_zone', 'online', 'poweredon_at', 'devicetime', 'free_space', 'now_playing', 'webui_password')
    d['company'] = company&.serialize
    d['playlist'] = playlist&.attributes&.slice('id', 'name', 'description')
    d['version'] = client_version.to_s
    d
  end
end
