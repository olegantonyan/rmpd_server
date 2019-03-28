class DeviceGroupsController < ApplicationController
  include Paginateble

  def index
    @device_groups = policy_scope(Device::Group.includes(:device_group_memberships, :devices)).limit(limit).offset(offset).order(created_at: :desc)
    authorize(@device_groups)
  end

  def new
    @device_group = Device::Group.new
    authorize(@device_group)
  end

  def edit
    @device_group = Device::Group.find(params[:id])
    authorize(@device_group)
  end

  def create
    @device_group = Device::Group.new(device_group_params)
    authorize(@device_group)

    if @device_group.save
      flash[:success] = t('views.device_groups.save_successfull')
      redirect_to(device_groups_path)
    else
      flash[:error] = @device_group.errors.full_messages.to_sentence
      render(:new)
    end
  end

  def update # rubocop: disable Metrics/AbcSize
    @device_group = Device::Group.find(params[:id])
    authorize(@device_group)

    if @device_group.update(device_group_params)
      flash[:success] = t('views.device_groups.save_successfull')
      redirect_to(device_groups_path)
    else
      flash[:error] = @device_group.errors.full_messages.to_sentence
      render(:edit)
    end
  end

  def destroy
    @device_group = Device::Group.find(params[:id])
    authorize(@device_group)

    if @device_group.destroy
      flash[:success] = t('views.device_groups.successfully_deleted')
      redirect_to(device_groups_path)
    else
      flash[:alert] = t('views.device_groups.error_delete')
      redirect_to(edit_device_group_path(@device_group))
    end
  end

  private

  def device_group_params
    params.require(:device_group).permit(:title, device_ids: [])
  end
end
