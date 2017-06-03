module Notifiers
  class DeviceBindNotifierJob < Notifiers::BaseNotifierJob
    def perform(device)
      text = "Device #{device} bound to #{device.company}"
      a = {
        fields: [{ title: 'Device login', value: device.login, short: true },
                 { title: 'Company', value: device.company.to_s, short: true }],
        color: 'good',
        fallback: text,
        author_name: device.to_s,
        author_link: device_url(device)
      }
      notify(text, icon_emoji: ':link:', attachments: [a])
    end
  end
end
