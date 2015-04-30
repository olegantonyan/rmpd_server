class Device < ActiveRecord::Base
  has_secure_password
  has_paper_trail
  belongs_to :playlist, touch: true
  has_one :device_status, dependent: :destroy
  has_many :device_log_messages
  has_many :device_group_memberships, dependent: :destroy
  has_many :device_groups, through: :device_group_memberships
  belongs_to :company
  
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
      configure :versions do 
        hide
      end
      configure :device_group_memberships do 
        hide
      end
      configure :password_digest do
        hide
      end
      configure :device_status do
        hide
      end
      configure :device_log_messages do
        hide
      end
    end
  end
  
  private
  
    def device_updated
      Deviceapi::Protocol.new.update_playlist self
    end
    
    def device_destroyed
      Deviceapi::Protocol.new.clear_queue self
    end
  
end
