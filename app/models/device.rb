class Device < ActiveRecord::Base
  has_secure_password
  belongs_to :playlist, touch: true
  has_one :device_status, :dependent => :destroy
  has_many :device_log
  
  validates_presence_of :login
  validates_uniqueness_of :login
  validates_length_of :login, :maximum => 130
  validates_length_of :name, :maximum => 130
  validates :password, confirmation: true
  validates_length_of :password, :in => 8..60
  
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
