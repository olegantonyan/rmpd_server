class Notifiers::ServiceUploadNotifierJob < Notifiers::BaseNotifierJob
  def perform(device)
    text = "Service upload from #{device}"
    a = {
      fields: [{ title: 'Device login', value: device.login, short: true }],
      color: 'warning',
      fallback: text,
      author_name: device.to_s,
      author_link:  device_device_service_uploads_path(device)
    }
    notify(text, icon_emoji: ':bowtie:', attachments: [a])
  end

  def slack_channel
    '#device_service_upload'
  end
end
