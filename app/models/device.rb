class Device < ActiveRecord::Base
  has_secure_password
  belongs_to :playlist, touch: true
  has_one :device_status, :dependent => :destroy
  has_many :device_log
  has_many :device_command_status, :dependent => :destroy
  
  validates_presence_of :login
  validates_uniqueness_of :login
  validates_length_of :login, :maximum => 130
  validates_length_of :name, :maximum => 130
  validates :password, length: {:in => 8..60}, :presence => true, :confirmation => true, :if => -> { new_record? || !password.nil? }
  
  after_save :device_updated
  after_destroy :device_destroyed
  
  private
  
    def device_updated
      Deviceapi::Protocol.new.update_playlist self
    end
    
    def device_destroyed
      Deviceapi::Protocol.new.clear_queue self
    end
  
end
