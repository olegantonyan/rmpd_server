class SshTunnelPolicy
  attr_reader :current_user, :ssh_tunnel
  
  def initialize(user, ssh_tunnel)
    @current_user = user
    @ssh_tunnel = ssh_tunnel
  end
  
  def index?
    @current_user.has_role? :root
  end  
  
end