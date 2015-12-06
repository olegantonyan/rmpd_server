class Device::LogMessage < ActiveRecord::Base
  belongs_to :device, inverse_of: :device_log_messages

  with_options presence: true do
    validates :command
    validates :localtime
  end
  with_options length: { maximum: 32_768 } do
    validates :user_agent
    validates :message
    validates :command
  end

  scope :ordered, -> { order(created_at: :desc) }

  rails_admin do
    visible false
  end

  def to_s
    "#{device} | #{command} | #{localtime} | #{message}"
  end

  def self.write!(device, logdata, user_agent)
    create!(device: device,
            localtime: Time.zone.parse(logdata[:localtime]),
            user_agent: user_agent,
            command: logdata[:command] || "#{logdata[:type]}_#{logdata[:status]}",
            message: logdata[:message] || logdata[:track])
  end
end
