class SshTunnel
  include ActiveModel::Model
  
  validates :server, :username, :server_port, :external_port, :internal_port, :open_duration, :device, presence: true
  validates :server, :username, length: {maximum: 130}
  validates :server_port, :external_port, :external_port, :internal_port, :open_duration, numericality: true
  validates :server_port, :external_port, :internal_port, inclusion: {in: 0..65535}
  validates :open_duration, inclusion: {in: 20..600}

  attr_accessor :server, :username, :server_port, :external_port, :internal_port, :open_duration, :device
  
  def save
    if valid?
      Deviceapi::Protocol.new.request_ssh_tunnel self
    else
      false
    end
  end

  def persisted?
    false
  end
  
end
