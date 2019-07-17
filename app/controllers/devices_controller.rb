class DevicesController < ApplicationController
  def index # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
    respond_to do |format|
      format.html do
        add_js_data(
          index_path: devices_path,
          show_path: device_path(':id'),
          playlist_path: edit_playlist_path(':id:')
        )
      end
      format.json do
        scoped = policy_scope(Device.includes(:playlist, :company))
        scoped = QueryObject.new(:search_query, :with_company_id).call(scoped, params)
        scoped = scoped.distinct

        total_count = scoped.count
        devices = Pagination.new(params).call(scoped).order(online: :desc)

        authorize(devices)

        render json: { data: devices.map(&:serialize), total_count: total_count }
      end
    end
  end

  def show
    @device = Device.find(params[:id])
    authorize(@device)

    add_js_data(
      device: @device.serialize,
      log_messages_path: device_device_log_messages_path(@device.id),
      playlists: policy_scope(Playlist.order(name: :asc)).map(&:serialize),
      playlist_assign_path: device_playlist_assign_path(@device.id),
      playlist_path: edit_playlist_path(':id:')
    )
  end

  def edit
    @device = Device.find(params[:id])
    authorize(@device)
    @companies = policy_scope(Company.all)
  end

  def update # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
    @device = Device.find(params[:id])

    time_zone_was = @device.time_zone # NOTE don't want to polute model with callbacks. also, don't want to overkill with service

    @device.assign_attributes(device_params)
    authorize(@device)
    @companies = policy_scope(Company.all)

    if @device.save
      flash[:success] = t('views.devices.update_successfull')

      @device.send_to(:update_setting, changed_attrs: %i[time_zone]) if time_zone_was != @device.time_zone

      redirect_to(device_path(@device))
    else
      flash[:error] = @device.errors.full_messages.to_sentence
      render(:edit)
    end
  end

  def delete_all_files
    device = Device.find(params[:id])
    device.send_to(:delete_all_files)
    flash[:success] = 'Command queued'
    redirect_to(device_path(device))
  end

  def reboot
    device = Device.find(params[:id])
    device.send_to(:reboot)
    flash[:success] = 'Command queued'
    redirect_to(device_path(device))
  end

  private

  def device_params
    params.require(:device).permit(policy(:device).permitted_attributes)
  end
end
