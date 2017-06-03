module Notifiers
  class SshTunnelNotifierJob < Notifiers::BaseNotifierJob
    def perform(device)
      text = "SSH tunnel open for device #{device}"
      a = {
        fields: [{ title: 'Device login', value: device.login, short: true }],
        color: 'good',
        fallback: text,
        author_name: device.to_s,
        author_link: device_url(device)
      }
      notify(text, icon_emoji: ':dusty_stick:', attachments: [a])
    end
  end
end
