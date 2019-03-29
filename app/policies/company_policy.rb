class CompanyPolicy < ApplicationPolicy
  def index?
    super || user&.companies&.exists?
  end

  def show?
    super || user.company_ids.include?(record.id)
  end

  def update?
    super || user.company_ids.include?(record.id)
  end

  def create?
    user.present?
  end

  def leave?
    record.includes_user?(user) && user.companies.size > 1
  end

  def destroy?
    super || record.includes_user?(user) && user.companies.size > 1
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.joins(:user_company_memberships).where('user_company_memberships.user_id = ?', user.id)
    end
  end

  def permitted_attributes
    if user&.root?
      [:title, user_ids: []]
    else
      [:title]
    end
  end
end
