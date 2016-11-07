class Device < ApplicationRecord
  include Deviceapi::Sender
  include Deviceapi::Receiver
  has_secure_password
  has_paper_trail

  mount_uploader :wallpaper, WallpaperUploader

  with_options dependent: :destroy do |a|
    a.with_options inverse_of: :device do |aa|
      aa.has_one :device_status, class_name: 'Device::Status', autosave: true
      aa.has_many :device_group_memberships, class_name: 'Device::Group::Membership'
      aa.has_many :device_log_messages, class_name: 'Device::LogMessage'
      aa.has_many :device_service_uploads, -> { order(created_at: :desc) }, class_name: 'Device::ServiceUpload'
    end
  end
  with_options inverse_of: :devices do |a|
    a.belongs_to :playlist
    a.belongs_to :company, optional: true
  end
  has_many :device_groups, through: :device_group_memberships, class_name: 'Device::Group'

  with_options presence: true do
    validates :login, uniqueness: true, length: { in: 4..100 }
    validates :password, length: { in: 8..60 }, confirmation: true, if: -> { new_record? || !password.nil? }
  end
  validates :name, length: { maximum: 40 }
  validate :wallpaper_max_size, if: 'wallpaper.present?'

  after_destroy { send_to :clear_queue }
  around_save :update_setting
  after_commit -> { send_to(:update_wallpaper) }, if: 'previous_changes[:wallpaper]'

  filterrific(available_filters: %i(search_query with_company_id with_device_group_id))

  scope :search_query, -> (query) {
    q = "%#{query}%"
    where('LOWER(name) LIKE LOWER(?) OR LOWER(login) LIKE LOWER(?)', q, q)
  }
  scope :with_company_id, -> (ids) { where(company_id: [*ids]) }
  scope :with_device_group_id, -> (ids) { joins(:device_groups).where(device_groups: { id: [*ids] }) }

  def online?
    device_status&.online
  end

  def to_s
    if name.blank?
      login
    else
      "#{login} (#{name})"
    end
  end

  def time_zone_formatted_offset
    tz = time_zone.blank? ? Rails.application.config.time_zone : time_zone
    ActiveSupport::TimeZone.new(tz).formatted_offset
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

  def self.message_queue_sync_periods
    o = Struct.new(:label, :value)
    [o.new('12 hours (default)', 12), o.new('3 hours', 3), o.new('6 hours', 6), o.new('24 hours', 24), o.new('3 days', 72),
     o.new('1 week', 168), o.new('1 month', 744), o.new('never', 0)]
  end

  private

  def wallpaper_max_size
    limit = 2.5
    errors.add(:wallpaper, "cannot be greater than #{limit}Mb") if wallpaper.file.size.to_f / (1024 * 1024) > limit
  end

  def update_setting
    changed_attrs = changed.map(&:to_sym).dup
    yield
    send_to(:update_setting, changed_attrs: changed_attrs) if changed_attrs & %i(time_zone message_queue_sync_period)
  end
end
