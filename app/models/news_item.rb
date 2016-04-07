class NewsItem < ApplicationRecord
  with_options presence: true do
    validates :title, length: { in: 4..100 }
    validates :body, length: { in: 4..6000 }
  end

  after_create :notify_users

  scope :latest, -> (count = 6) { order(created_at: :desc).limit(count) }

  def to_s
    title
  end

  private

  def notify_users
    NewsMailer.notify(self).deliver_later(wait: 5.minutes)
  end
end
