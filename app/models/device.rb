class Device < ActiveRecord::Base
  include Deviceapi::Sender
  include Deviceapi::Receiver
  include ScopesWithUser
  has_secure_password
  has_paper_trail

  with_options dependent: :destroy do |a|
    a.with_options inverse_of: :device do |aa|
      aa.has_one :device_status, class_name: Device::Status, autosave: true
      aa.has_many :device_group_memberships, class_name: Device::Group::Membership
      aa.has_many :device_log_messages, class_name: Device::LogMessage
    end
  end
  with_options inverse_of: :devices do |a|
    a.belongs_to :playlist, touch: true
    a.belongs_to :company
  end
  has_many :device_groups, through: :device_group_memberships, class_name: Device::Group

  validates :login, presence: true, uniqueness: true, length: {:in => 4..100}
  validates :name, length: {maximum: 130}
  validates :password, length: {in: 8..60}, presence: true, confirmation: true, if: -> { new_record? || !password.nil? }

  after_save :device_updated
  after_destroy :device_destroyed

  def online?
    device_status && device_status.online
  end

  rails_admin do
    list do
      field :name
      field :login
      field :playlist
      field :company
      field :device_groups
    end
    show do
      exclude_fields :password_digest, :device_log_messages, :device_group_memberships, :device_status
    end
    edit do
      exclude_fields :versions, :device_group_memberships, :password_digest, :device_status, :device_log_messages
    end
  end

  def to_s
    "#{name} (#{login} in #{company.to_s})"
  end

  private

  def device_updated
    send_to :update_playlist
  end

  def device_destroyed
    send_to :clear_queue
  end

end
