class InvitePolicy < ApplicationPolicy
  def create?
    super || record.company.includes_user?(user)
  end

  def destroy?
    record.user == user
  end
end
