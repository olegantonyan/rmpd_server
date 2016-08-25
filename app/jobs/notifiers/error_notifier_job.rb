class Notifiers::ErrorNotifierJob < Notifiers::BaseNotifierJob
  def perform(device, text)
    notify(text, icon_emoji: ':hurtrealbad:', attachments: attachments(device, text))
  end

  def slack_channel
    '#device_errors'
  end

  private

  def attachments(device, text)
    [{
      fields: [{ title: 'Device login', value: device.login, short: false }],
      color: 'danger',
      fallback: text,
      text: text,
      author_name: device.to_s,
      author_link: device_url(device)
    }]
  end
end
