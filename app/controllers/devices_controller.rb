class DevicesController < ApplicationController
  include Paginateble

  def index # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
    respond_to do |format|
      format.html do
        add_js_data(
          index_path: devices_path,
          show_path: device_path(':id')
        )
      end
      format.json do
        scoped = policy_scope(Device.includes(:playlist, :company))
        scoped = QueryObject.new(:search_query, :with_company_id).call(scoped, params)
        scoped = scoped.distinct

        total_count = scoped.count
        devices = scoped.limit(limit).offset(offset).order(online: :desc)

        authorize(devices)

        render json: { data: devices.map(&:to_hash), total_count: total_count }
      end
    end
  end

  def show
    @device = Device.find(params[:id])
    authorize(@device)

    add_js_data(
      device: @device.to_hash,
      log_messages_path: device_device_log_messages_path(@device.id)
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

      if time_zone_was != @device.time_zone
        @device.send_to(:update_setting, changed_attrs: %i[time_zone])
      end

      redirect_to(device_path(@device))
    else
      flash[:error] = @device.errors.full_messages.to_sentence
      render(:edit)
    end
  end

  private

  def device_params
    params.require(:device).permit(policy(:device).permitted_attributes)
  end
end
