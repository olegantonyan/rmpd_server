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
      flash_success("SSH tunnel requested for '#{@device.login}'. Example use for device user 'rmpd': ssh rmpd@#{@ssh_tunnel.server} -p #{@ssh_tunnel.external_port}")
      redirect_to @device
    else
      flash_error('Error creating SSH tunnel')
      render :new
    end
  end

  private

  def set_device
    @device = Device.find(params[:device_id])
  end

  def ssh_tunnel_params
    result = params.require(:ssh_tunnel).permit(:server, :username, :server_port, :external_port, :internal_port, :open_duration)
    result[:server_port] = result[:server_port].to_i
    result[:external_port] = result[:external_port].to_i
    result[:internal_port] = result[:internal_port].to_i
    result[:open_duration] = result[:open_duration].to_i
    result
  end
end
