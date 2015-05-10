class CompanyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.joins(:user_company_memberships).where('user_company_memberships.user_id = ?', user.id)
    end
  end
end