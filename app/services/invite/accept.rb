class Invite::Accept < BaseService
  attr_accessor :user, :invite

  with_options presence: true do
    validates :user
    validates :invite
  end
  validate :invite_for_this_user
  validate :user_already_a_member

  delegate :to_s, to: :invite, allow_nil: true

  def save
    return false unless valid?
    user.companies << invite.company
    invite.update(accepted: true)
  end

  private

  def invite_for_this_user
    return unless user
    return unless invite
    errors.add(:user, "invited user's email does'n match with invited (#{user.email} != #{invite.email})") unless user.email == invite.email
  end

  def user_already_a_member
    return unless user
    return unless invite
    errors.add(:user, 'user is already a member of the company') if invite.company.includes_user?(user)
  end
end
