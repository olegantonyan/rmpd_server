class InvitePolicy < ApplicationPolicy
  def create?
    super || record.company.includes_user?(user)
  end

  def destroy?
    super || record.user == user
  end

  def permitted_attributes
    [:email]
  end
end
