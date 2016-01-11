class DeviceLogMessagesController < BaseController
  include Filterrificable

  # rubocop: disable Metrics/AbcSize, Metrics/MethodLength, Style/Semicolon
  def index
    @filterrific = initialize_filterrific(
      Device::LogMessage,
      params[:filterrific]
    ) || (on_reset; return)
    filtered = @filterrific.find.page(params[:page]).per_page(params[:per_page] || 100)
    @device_log_messages = policy_scope(filtered.where(device_id: params[:device_id])).ordered
    authorize @device_log_messages

    respond_to do |format|
      format.html
      format.js
      format.csv { render text: @device_log_messages.to_csv }
    end
  end
  # rubocop: enable Metrics/AbcSize, Metrics/MethodLength, Style/Semicolon
end
