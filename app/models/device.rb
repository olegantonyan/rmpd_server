class Device < ActiveRecord::Base
  has_secure_password
  has_paper_trail

  belongs_to :playlist, touch: true, inverse_of: :devices
  has_one :device_status, dependent: :destroy, inverse_of: :device, class_name: Device::Status
  has_many :device_log_messages, dependent: :destroy, class_name: Device::LogMessage
  has_many :device_group_memberships, dependent: :destroy, inverse_of: :device, class_name: Device::Group::Membership
  has_many :device_groups, through: :device_group_memberships, class_name: Device::Group
  belongs_to :company, inverse_of: :devices

  validates :login, presence: true, uniqueness: true, length: {:in => 4..100}
  validates_length_of :name, :maximum => 130
  validates :password, length: {:in => 8..60}, :presence => true, :confirmation => true, :if => -> { new_record? || !password.nil? }

  after_save :device_updated
  after_destroy :device_destroyed

  def online?
    self.device_status != nil && self.device_status.online
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
      Deviceapi::Protocol.new.update_playlist self
    end

    def device_destroyed
      Deviceapi::Protocol.new.clear_queue self
    end

end
