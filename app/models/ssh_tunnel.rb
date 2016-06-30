class SshTunnel < ApplicationModel
  validates :server, :username, :server_port, :external_port, :internal_port, :open_duration, :device, presence: true
  validates :server, :username, length: { maximum: 130 }
  validates :server_port, :external_port, :external_port, :internal_port, :open_duration, numericality: true
  validates :server_port, :external_port, :internal_port, inclusion: { in: 0..65_535 }
  validates :open_duration, inclusion: { in: 20..600 }

  before_validation :cast_attrs

  attr_accessor :server, :username, :server_port, :external_port, :internal_port, :open_duration, :device

  def self.new_default(host)
    new.tap do |s|
      s.server = host
      s.username = 'sshtunnel'
      s.server_port = 10_022
      s.external_port = 10_023
      s.internal_port = 22
      s.open_duration = 120
    end
  end

  def save
    if valid?
      device.send_to(:request_ssh_tunnel, tunnel: self)
    else
      false
    end
  end

  def to_s
    "to #{server} via #{username}"
  end

  private

  def cast_attrs
    %w(server_port external_port internal_port open_duration).map(&:to_sym).each do |attr|
      send("#{attr}=", send(attr).to_i)
    end
  end
end
