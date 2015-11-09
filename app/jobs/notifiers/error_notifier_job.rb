class Notifiers::ErrorNotifierJob < Notifiers::BaseNotifierJob
  def perform(device, text)
    a = {
      fields: [{
          title: "Device login",
          value: device.login,
          short: false
        }
      ],
      color: 'danger',
      fallback: text,
      text: text,
      author_name: device.to_s,
      author_link: device_url(device),
    }
    notify(text, icon_emoji: ':hurtrealbad:', attachments: [a])
  end
end
