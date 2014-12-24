class Device < ActiveRecord::Base
  has_secure_password
  belongs_to :playlist, touch: true
  has_one :device_status, :dependent => :destroy
  has_many :device_log
  validates :login, presence: true
  
  after_save :device_updated
  
  private
  
    def device_updated
      Deviceapi::Protocol.new.update_playlist self
    end
  
end
