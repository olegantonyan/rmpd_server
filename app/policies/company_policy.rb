class CompanyPolicy < ApplicationPolicy
  def index?
    super || user&.companies&.exists?
  end

  def show?
    super || user.company_ids.include?(record.id)
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.joins(:user_company_memberships).where('user_company_memberships.user_id = ?', user.id).where.not(id: Company.demo.id)
    end
  end
end
