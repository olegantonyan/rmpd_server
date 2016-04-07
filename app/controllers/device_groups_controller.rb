class DeviceGroupsController < BaseController
  include Filterrificable

  before_action :set_device_group, only: %i(show edit update destroy)

  # GET /device_groups
  # GET /device_groups.json
  # rubocop: disable Metrics/AbcSize, Style/Semicolon, Style/RedundantParentheses
  def index
    @filterrific = initialize_filterrific(
      Device::Group,
      params[:filterrific],
      select_options: {
        with_device_id: policy_scope(Device.all).map { |e| [e.name, e.id] }
      }
    ) || (on_reset; return)
    filtered = @filterrific.find.page(page).per_page(per_page)
    @device_groups = policy_scope(filtered).order(created_at: :asc).page(page).per_page(per_page)
    authorize @device_groups
  end
  # rubocop: enable Metrics/AbcSize, Style/Semicolon, Style/RedundantParentheses

  # GET /device_groups/1
  # GET /device_groups/1.json
  def show
    authorize @device_group
  end

  # GET /device_groups/new
  def new
    @device_group = Device::Group.new
    authorize @device_group
  end

  # GET /device_groups/1/edit
  def edit
    authorize @device_group
  end

  # POST /device_groups
  # POST /device_groups.json
  def create
    @device_group = Device::Group.new(device_group_params)
    authorize @device_group
    crud_respond @device_group, success_url: device_groups_path
  end

  # PATCH/PUT /device_groups/1
  # PATCH/PUT /device_groups/1.json
  def update
    authorize @device_group
    @device_group.assign_attributes(device_group_params)
    crud_respond @device_group, success_url: device_group_path(@device_group)
  end

  # DELETE /device_groups/1
  # DELETE /device_groups/1.json
  def destroy
    authorize @device_group
    crud_respond @device_group, success_url: device_groups_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_device_group
    @device_group = Device::Group.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def device_group_params
    params.require(:device_group).permit(:title, device_ids: [])
  end
end
