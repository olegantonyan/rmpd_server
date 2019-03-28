class Company
  class Leave
    include ActiveModel::Model
    include ActiveModel::Validations
    extend ActiveModel::Translation

    attr_accessor :company, :user

    validate :user_in_this_company
    validates :user, presence: true
    validates :company, presence: true

    def save
      return false if invalid?
      company.users.delete(user)
      true
    end

    private

    def user_in_this_company
      return unless user
      return unless company
      errors.add(:user, "is not a member of this company #{company}") unless company.user_ids.include?(user.id)
    end
  end
end
