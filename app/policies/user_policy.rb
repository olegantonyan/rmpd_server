class UserPolicy < ApplicationPolicy
  def show?
    super || user == record
  end

  def update?
    super || user == record
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.joins(:companies).where('companies.id in (?)', user.company_ids)
    end
  end
end