class NewsItem < ActiveRecord::Base
  validates :title, presence: true, length: {:in => 4..100}
  validates :body, presence: true, length: {:in => 4..6000}
  
  after_create :notify_users
  
  private
  
    def notify_users
      SendNewsNotificationEmailJob.set(wait: 5.minutes).perform_later(User.where.not(:confirmed_at => nil, :allow_notifications => false).to_a, self)
    end
end
