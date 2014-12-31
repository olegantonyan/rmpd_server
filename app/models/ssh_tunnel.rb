class SshTunnel
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  validates_presence_of :server
  validates_presence_of :username
  validates_presence_of :server_port
  validates_presence_of :external_port
  validates_presence_of :internal_port
  validates_presence_of :open_duration
  validates_presence_of :device
  validates_length_of :server, :maximum => 130
  validates_length_of :username, :maximum => 130
  validates_numericality_of :server_port
  validates_numericality_of :external_port
  validates_numericality_of :internal_port
  validates_numericality_of :open_duration
  validates_inclusion_of :server_port, :in => 0..65535
  validates_inclusion_of :external_port, :in => 0..65535
  validates_inclusion_of :internal_port, :in => 0..65535
  validates_inclusion_of :open_duration, :in => 20..600

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
