class DeviceLogMessagesController < ApplicationController
  def index
    scoped = policy_scope(Device::LogMessage.where(device_id: params[:device_id])).includes(:device)
    scoped = scoped.distinct

    total_count = scoped.count
    log_messages = pagination.call(scoped).ordered

    authorize(log_messages)

    render json: { data: log_messages.map(&:serialize), total_count: total_count }
  end

  private

  def pagination
    @pagination ||= Pagination.new(params, default_limit: 100)
  end
end
