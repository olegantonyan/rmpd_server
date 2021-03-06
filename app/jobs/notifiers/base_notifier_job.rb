module Notifiers
  class BaseNotifierJob < ApplicationJob
    queue_as :notifiers

    def slack_channel
      '#dev'
    end

    def slack_webhook_url
      APP_CONFIG.fetch(:slack, {}).fetch(:webhook_url, nil)
    rescue NameError
      nil
    end

    protected

    def notifier
      if slack_webhook_url
        Slack::Notifier.new(slack_webhook_url, username: self.class.name, channel: slack_channel)
      else
        Rails.logger.warn('slack notification is not configured')
        nil
      end
    end

    def notify(text, options = {})
      notifier&.ping(text || '<NO ERROR MESSAGE>', options)
    end
  end
end
