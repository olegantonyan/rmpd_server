class Device::LogMessage < ActiveRecord::Base
  belongs_to :device, inverse_of: :device_log_messages

  validates_presence_of :command, :localtime
  with_options maximum: 32768 do
    validates_length_of :user_agent, :message, :command
  end

  rails_admin do
    visible false
  end

  def to_s
    "#{device.to_s} | #{command} | #{localtime} | #{message}"
  end

end
