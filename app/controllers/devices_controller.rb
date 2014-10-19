class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  before_action :set_active_menu_item

  # GET /devices
  def index
    @devices = Device.all
    #Xmpp.message "Хелло, ворлд!"
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
  # POST /devices.json
  def create
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        flash_success 'Device was successfully created'
        format.html { redirect_to @device }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /devices/1
  def update
    respond_to do |format|
      if @device.update(device_params)
        flash_success 'Device was successfully updated'
        format.html { redirect_to @device }
      else
        flash_error 'Error creating device'
        format.html { render :edit }
      end
    end
  end

  # DELETE /devices/1
  def destroy
    @device.destroy
    respond_to do |format|
      flash_success  'Device was successfully deleted'
      format.html { redirect_to devices_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:serial_number, :name)
    end
    
    def set_active_menu_item
      @active_devices = "active"
    end
end
