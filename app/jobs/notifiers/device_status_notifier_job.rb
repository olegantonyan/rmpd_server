module Notifiers
  class DeviceStatusNotifierJob < Notifiers::BaseNotifierJob
    def perform(device, status, thetime) # rubocop: disable Metrics/MethodLength
      status_text = status ? 'online' : 'offline'
      text = "Device #{device} is now #{status_text} (#{thetime})"
      color = status ? 'good' : 'warning'
      a = {
        fields: [{ title: 'Device login', value: device.login, short: true },
                 { title: 'Device status', value: status_text, short: true },
                 { title: 'Datetime (local)', value: Time.zone.parse(thetime).localtime.to_s, short: true }],
        color: color,
        fallback: text,
        author_name: device.to_s,
        author_link: device_url(device)
      }
      notify(text, icon_emoji: ':squirrel:', attachments: [a])
    end

    def slack_channel
      '#device_status'
    end
  end
end
