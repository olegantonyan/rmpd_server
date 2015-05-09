class SendNewsNotificationEmailJob < ActiveJob::Base
  queue_as :email_notifications

  def perform(users, news_item)
    users.each do |user|
      NewsMailer.notify(user, news_item).deliver_later
    end
  end
end
