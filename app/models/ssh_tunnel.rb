class SshTunnel
  include ActiveModel::Model

  validates :server, :username, :server_port, :external_port, :internal_port, :open_duration, :device, presence: true
  validates :server, :username, length: {maximum: 130}
  validates :server_port, :external_port, :external_port, :internal_port, :open_duration, numericality: true
  validates :server_port, :external_port, :internal_port, inclusion: {in: 0..65535}
  validates :open_duration, inclusion: {in: 20..600}

  attr_accessor :server, :username, :server_port, :external_port, :internal_port, :open_duration, :device

  def self.new_default(host)
    ssh_tunnel = new
    ssh_tunnel.server = host
    ssh_tunnel.username = "sshtunnel"
    ssh_tunnel.server_port = 10022
    ssh_tunnel.external_port = 10023
    ssh_tunnel.internal_port = 22
    ssh_tunnel.open_duration = 120
    ssh_tunnel
  end

  def save
    if valid?
      device.send_to(:request_ssh_tunnel, {tunnel: self})
    else
      false
    end
  end

end
