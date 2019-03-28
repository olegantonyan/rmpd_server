class Invite
  class Accept
    include ActiveModel::Model
    include ActiveModel::Validations
    extend ActiveModel::Translation

    attr_accessor :user, :invite

    validates :user, presence: true
    validates :invite, presence: true
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
      errors.add(:user, "invited user's email doesn't match with invited (#{user.email} != #{invite.email})") unless user.email == invite.email
    end

    def user_already_a_member
      return unless user
      return unless invite
      errors.add(:user, 'user is already a member of the company') if invite.company.includes_user?(user)
    end
  end
end
