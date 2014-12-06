class Device < ActiveRecord::Base
  belongs_to :playlist, touch: true
  has_one :device_status, :dependent => :destroy
  has_many :device_log
  
  after_save :device_updated
  before_save :set_login
  
  private
    def set_login
      self.login = "#{self.serial_number}@#{APP_CONFIG['broker_address']}"
    end
  
    def device_updated
      RemoteProtocol.new.update_playlist self
    end
  
end
