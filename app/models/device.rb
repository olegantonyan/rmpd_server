class Device < ActiveRecord::Base
  belongs_to :playlist
  has_one :device_status
  
  after_save :device_updated
  before_save :set_login
  
  private
    def set_login
      self.login = "#{self.serial_number}@#{APP_CONFIG['broker_address']}"
    end
  
    def device_updated
      d = DeviceRemoteConnector.new
      d.send_message self.login, "device updated"

    end
  
end
