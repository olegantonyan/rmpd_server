class Notifiers::BaseNotifierJob < ApplicationJob
  queue_as :notifiers

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
