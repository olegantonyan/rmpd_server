class CompanyPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.root? || user.company_ids.include?(record.id)
  end

  def create?
    user.root?
  end

  def destroy?
    user.root?
  end

  def update
    user.root?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.joins(:user_company_memberships).where('user_company_memberships.user_id = ?', user.id)
    end
  end
end
