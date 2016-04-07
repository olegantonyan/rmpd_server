class Device < ApplicationRecord
  include Deviceapi::Sender
  include Deviceapi::Receiver
  has_secure_password
  has_paper_trail

  with_options dependent: :destroy do |a|
    a.with_options inverse_of: :device do |aa|
      aa.has_one :device_status, class_name: 'Device::Status', autosave: true
      aa.has_many :device_group_memberships, class_name: 'Device::Group::Membership'
      aa.has_many :device_log_messages, class_name: 'Device::LogMessage'
    end
  end
  with_options inverse_of: :devices do |a|
    a.belongs_to :playlist
    a.belongs_to :company
  end
  has_many :device_groups, through: :device_group_memberships, class_name: 'Device::Group'

  validates :login, presence: true, uniqueness: true, length: { in: 4..100 }
  validates :name, length:  { maximum: 130 }
  validates :password, length: { in: 8..60 }, presence: true, confirmation: true, if: -> { new_record? || !password.nil? }

  after_destroy { send_to :clear_queue }
  around_save :update_setting

  filterrific(available_filters: %i(search_query with_company_id with_device_group_id))

  scope :search_query, -> (query) {
    q = "%#{query}%"
    where('LOWER(name) LIKE LOWER(?) OR LOWER(login) LIKE LOWER(?)', q, q)
  }
  scope :with_company_id, -> (ids) { where(company_id: [*ids]) }
  scope :with_device_group_id, -> (ids) { joins(:device_groups).where(device_groups: { id: [*ids] }) }

  def online?
    device_status && device_status.online
  end

  def to_s
    "#{login} (#{name} in #{company})"
  end

  def time_zone_formatted_offset
    tz = time_zone.blank? ? Rails.application.config.time_zone : time_zone
    ActiveSupport::TimeZone.new(tz).formatted_offset
  end

  def synchronizing?
    Deviceapi::MessageQueue.find_by(key: login, message_type: :update_playlist)
  end

  private

  def update_setting
    changed_attrs = changed.map(&:to_sym).dup
    yield
    send_to(:update_setting, changed_attrs: changed_attrs) if changed_attrs.include?(:time_zone)
  end
end
