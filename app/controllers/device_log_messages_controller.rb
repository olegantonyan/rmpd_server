class DeviceLogMessagesController < ApplicationController
  include Paginateble

  def index # rubocop: disable Metrics/AbcSize
    scoped = policy_scope(Device::LogMessage.where(device_id: params[:device_id])).includes(:device)
    scoped = scoped.distinct

    total_count = scoped.count
    log_messages = scoped.limit(limit).offset(offset).ordered

    authorize(log_messages)

    render json: { data: log_messages.map(&:serialize), total_count: total_count }
  end

  private

  def default_limit
    100
  end
end
