class Notifiers::BaseNotifierJob < ApplicationJob
  queue_as :notifiers

  SLACK_WEBHOOK_URL = 'https://hooks.slack.com/services/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'

  protected

  def notifier
    webhook_url = APP_CONFIG.fetch(:slack, {}).fetch(:webhook_url, nil)
    if webhook_url
      Slack::Notifier.new webhook_url, username: self.class.name
    end
  end

  def notify(text, options = {})
    notifier.try(:ping, text, options)
  end

end
