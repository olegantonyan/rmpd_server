class Notifiers::ServiceUploadNotifierJob < Notifiers::BaseNotifierJob
  def perform(device)
    text = "Service upload from #{device} (<#{device_device_service_uploads_url(device)}>)"
    notify(text, icon_emoji: ':bowtie:')
  end

  def slack_channel
    '#device_service_upload'
  end
end
