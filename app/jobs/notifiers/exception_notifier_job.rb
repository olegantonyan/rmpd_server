class Notifiers::ExceptionNotifierJob < Notifiers::BaseNotifierJob

  def self.call(ex)
    Notifiers::ExceptionNotifierJob.perform_later ex.class.name, ex.message, ex.backtrace.try(:join, "\n")
  end

  def perform(class_name, message, backtrace)
    backtrace = backtrace[0..3000] + '...'
    a = {
      fields: [{
          title: 'Enviroment',
          value: Rails.env,
          short: true
        }
      ],
      color: 'danger',
      fallback: "#{class_name}:#{message}",
      text: "```" + backtrace + "```",
      pretext: message,
      mrkdwn_in: ['text', 'pretext']
    }
    notify(class_name, icon_emoji: ':bug:', attachments: [a])
  end
end
