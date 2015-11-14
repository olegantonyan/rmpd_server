class Notifiers::BaseNotifierJob < ApplicationJob
  queue_as :notifiers

  SLACK_WEBHOOK_URL = APP_CONFIG.fetch(:slack, {}).fetch(:webhook_url, nil)

  protected

  def notifier
    if SLACK_WEBHOOK_URL
      Slack::Notifier.new SLACK_WEBHOOK_URL, username: self.class.name
    end
  end

  def notify(text, options = {})
    notifier.try(:ping, text, options)
  end

end
