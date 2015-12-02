class Notifiers::DeviceStatusNotifierJob < Notifiers::BaseNotifierJob
  # rubocop: disable Metrics/MethodLength
  def perform(device, status)
    status_text = status ? 'online' : 'offline'
    text = "Device #{device} is now #{status_text}"
    color = status ? 'good' : 'warning'
    a = {
      fields: [{ title: 'Device login', value: device.login, short: true },
               { title: 'Device status', value: status_text, short: true }],
      color: color,
      fallback: text,
      author_name: device.to_s,
      author_link: device_url(device)
    }
    notify(text, icon_emoji: ':squirrel:', attachments: [a])
  end
  # rubocop: enable Metrics/MethodLength
end
