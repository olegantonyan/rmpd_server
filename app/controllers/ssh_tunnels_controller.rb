class SshTunnelsController < BaseController
  before_action :set_device

  def new
    @ssh_tunnel = SshTunnel.new_default(request.host)
    authorize @ssh_tunnel
  end

  def create
    @ssh_tunnel = SshTunnel.new(ssh_tunnel_params)
    @ssh_tunnel.device = @device
    authorize @ssh_tunnel
    if @ssh_tunnel.save
      flash[:notice] = "Tunnel requested for '#{@device.login}'. Example for device user 'rmpd': ssh rmpd@#{@ssh_tunnel.server} -p #{@ssh_tunnel.external_port}"
      redirect_to @device
    else
      flash[:alert] = 'Error creating SSH tunnel'
      render :new
    end
  end

  private

  def set_device
    @device = Device.find(params[:device_id])
  end

  def ssh_tunnel_params
    params.require(:ssh_tunnel).permit(:server, :username, :server_port, :external_port, :internal_port, :open_duration)
  end
end
