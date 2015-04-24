class DevicesController < UsersApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  before_action :set_playlists, only: [:edit, :new, :create, :update]
  before_action :set_device_groups, only: [:edit, :create, :update, :new]
  
  # GET /devices
  def index
    @devices = Device.all.includes(:device_status, :playlist).order(:name => :asc)
  end

  # GET /devices/1
  def show
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  def create
    @device = Device.new(device_params)
    
    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, flash_success(t(:device_successfully_created, :name => @device.login)) }
      else
        format.html { render :new, flash_error(t(:error_creating_device)) }
      end
    end
  end

  # PATCH/PUT /devices/1
  def update
    respond_to do |format|
      if @device.update(device_params) 
        format.html { redirect_to @device, flash_success(t(:device_successfully_updated, :name => @device.login)) }
      else
        format.html { render :edit, flash_error(t(:error_updating_device)) }
      end
    end
  end

  # DELETE /devices/1
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_path, flash_success(t(:device_successfully_deleted, :name => @device.login))}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.includes(:device_groups).find(params[:id])
      @enable_admin_area = true#APP_CONFIG['username'] == 'admin'
    end
    
    def set_playlists
      @playlists = Playlist.order(:name => :asc)
    end
    
    def set_device_groups
      @device_groups = DeviceGroup.order(:title => :asc)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:login, :name, :password, :password_confirmation, :playlist_id, :device_group_ids => [])
    end
    
end
