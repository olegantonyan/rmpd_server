class DeviceBindsController < ApplicationController
  def new
    @device_bind = Device::Bind.new
    @device_bind.time_zone = 'Kaliningrad' # get default from user's browser/account somehow?
    @device_bind.company_id = current_user.companies.first.id
    @companies = policy_scope(Company.all)
    authorize(@device_bind)
  end

  def create # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
    @device_bind = Device::Bind.new(device_bind_params)
    @device_bind.company_id = current_user.companies.first.id unless @device_bind.company_id
    @companies = policy_scope(Company.all)
    authorize(@device_bind)
    if @device_bind.save
      flash[:success] = t('views.devices.bind_successfull', device: @device_bind.device, company: @device_bind.company)
      redirect_to(devices_path)
    else
      flash[:error] = @device_bind.errors.full_messages.to_sentence
      render(:new)
    end
  end

  private

  def device_bind_params
    params.require(:device_bind).permit(:login, :company_id, :name, :time_zone)
  end
end
