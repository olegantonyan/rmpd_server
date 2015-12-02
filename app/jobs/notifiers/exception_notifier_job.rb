class Notifiers::ExceptionNotifierJob < Notifiers::BaseNotifierJob
  def self.call(ex)
    perform_later ex.class.name, ex.message, ex.backtrace.try(:join, "\n")
  end

  def perform(class_name, message, backtrace)
    notify(class_name, icon_emoji: ':bug:', attachments: attachments(class_name, message, backtrace))
  end

  private

  def attachments(class_name, message, backtrace)
    backtrace = backtrace[0..3000] + '...'
    [{
      fields: [{ title: 'Enviroment', value: Rails.env, short: true }],
      color: 'danger',
      fallback: "#{class_name}:#{message}",
      text: '```' + backtrace + '```',
      pretext: message,
      mrkdwn_in: %w(text pretext)
    }]
  end
end
