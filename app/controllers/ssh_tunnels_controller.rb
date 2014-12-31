class SshTunnelsController < UsersApplicationController
  before_action :set_device
  before_action :set_tunnel
  
  def index
  end
  
  def create
    @ssh_tunnel.server = params[:ssh_tunnel][:server].to_s
    @ssh_tunnel.username = params[:ssh_tunnel][:username].to_s
    @ssh_tunnel.server_port = params[:ssh_tunnel][:server_port].to_i
    @ssh_tunnel.external_port = params[:ssh_tunnel][:external_port].to_i
    @ssh_tunnel.internal_port = params[:ssh_tunnel][:internal_port].to_i
    @ssh_tunnel.open_duration = params[:ssh_tunnel][:open_duration].to_i
    @ssh_tunnel.device = @device
    respond_to do |format|
      if @ssh_tunnel.save
        flash_success "SSH tunnel requested for '#{@device.login}'"
        format.html { redirect_to @device }
      else
        flash_error 'Error SSH tunnel'
        format.html { render :index }
      end
    end
  end
  
  private
  
  def set_device
    @device = Device.find(params[:device_id])
  end
  
  def set_tunnel
    @ssh_tunnel = SshTunnel.new
    @ssh_tunnel.server = request.host
    @ssh_tunnel.username = "sshtunnel"
    @ssh_tunnel.server_port = 10022
    @ssh_tunnel.external_port = 10023
    @ssh_tunnel.internal_port = 22
    @ssh_tunnel.open_duration = 120
  end
  
end
