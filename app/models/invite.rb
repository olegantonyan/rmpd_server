class Invite < ApplicationRecord
  has_paper_trail

  with_options inverse_of: :invites do |a|
    a.belongs_to :company
    a.belongs_to :user
  end

  with_options presence: true do
    validates :company
    validates :user
    validates :email
  end
  validates :email, format: { with: Devise.email_regexp }

  before_create :generate_token
  after_create :send_notification

  def to_s
    "#{email} -> #{company}"
  end

  private

  def generate_token
    self.token = Digest::SHA1.hexdigest([user.id, company.id, Time.current, rand].join)
  end

  def send_notification
    InviteMailer.invitation(self).deliver_later
  end
end
