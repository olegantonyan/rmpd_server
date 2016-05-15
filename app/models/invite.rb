class Invite < ApplicationRecord
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

  scope :accepted, -> { where(accepted: true) }
  scope :pending, -> { where(accepted: false) }

  before_create :generate_token
  after_create :send_notification

  def accepted_by
    User.find_by(email: email)
  end

  def accepted?
    self.class.accepted.exists?(id: id)
  end

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
