module Notifiers
  class SoftwareUpdateNotifierJob < Notifiers::BaseNotifierJob
    def perform(device, ok, text)
      notify(text, icon_emoji: ':earth_africa:', attachments: attachments(device, ok, text))
    end

    private

    def attachments(device, ok, text)
      [{
        fields: [{ title: 'Device login', value: device.login, short: false }],
        color: ok ? 'good' : 'danger',
        fallback: text,
        text: text,
        author_name: device.to_s,
        author_link: device_url(device)
      }]
    end
  end
end
