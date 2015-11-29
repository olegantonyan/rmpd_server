class Device::LogMessage < ActiveRecord::Base
  belongs_to :device, inverse_of: :device_log_messages

  validates_presence_of :command, :localtime
  with_options maximum: 32768 do
    validates_length_of :user_agent, :message, :command
  end

  def self.write!(device, logdata, user_agent)
    return false if [logdata[:status], logdata[:command]].any? {|i| i == 'now_playing'}

    create!(device: device,
            localtime: Time.parse(logdata[:localtime]),
            user_agent: user_agent,
            command: logdata[:command] || "#{logdata[:type]}_#{logdata[:status]}",
            message: logdata[:message] || logdata[:track])
  rescue ArgumentError => e
    logger.error "error writing device log: #{e.message}"
  end

  rails_admin do
    visible false
  end

  def to_s
    "#{device.to_s} | #{command} | #{localtime} | #{message}"
  end

end
