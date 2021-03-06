class Invite < ApplicationRecord
  belongs_to :company, inverse_of: :invites
  belongs_to :user, inverse_of: :invites

  validates :company, presence: true
  validates :user, presence: true
  validates :email, presence: true
  validates :email, format: { with: Devise.email_regexp }

  before_create :generate_token

  def user_exists?
    User.exists?(email: email)
  end

  def to_s
    "#{email} -> #{company}"
  end

  private

  def generate_token
    self.token = Digest::SHA1.hexdigest([user.id, company.id, Time.current, rand].join)
  end
end
