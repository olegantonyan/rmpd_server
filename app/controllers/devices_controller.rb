class DevicesController < BaseController
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  before_action :set_playlists, only: [:edit, :new, :create, :update]
  before_action :set_device_groups, only: [:edit, :create, :update, :new]

  # GET /devices
  def index
    @devices = policy_scope(Device.all).includes(:device_status, :playlist, :device_groups, :company).order(name: :asc)
    authorize @devices
  end

  # GET /devices/1
  def show
    authorize @device
  end

  # GET /devices/new
  def new
    @device = Device.new
    authorize @device
  end

  # GET /devices/1/edit
  def edit
    authorize @device
  end

  # POST /devices
  def create
    @device = Device.new(device_params)
    authorize @device
    crud_respond @device, success_url: devices_path
  end

  # PATCH/PUT /devices/1
  def update
    authorize @device
    @device.assign_attributes(device_params)
    crud_respond @device, success_url: device_path(@device)
  end

  # DELETE /devices/1
  def destroy
    authorize @device
    crud_respond @device, success_url: devices_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_device
    @device = policy_scope(Device.all).includes(:device_groups).find(params[:id])
  end

  def set_playlists
    @playlists = policy_scope(Playlist.all).order(name: :asc)
  end

  def set_device_groups
    @device_groups = policy_scope(Device::Group.order(title: :asc))
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def device_params
    params.require(:device).permit(:login, :name, :password, :password_confirmation, :company_id, device_group_ids: [])
  end
end
