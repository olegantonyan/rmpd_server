class UserPolicy < ApplicationPolicy
  def index?
    super || (user.present? && user.companies.includes(:users).map(&:users).flatten.uniq.count > 1)
  end

  def show?
    super || user == record || (user.company_ids & record.company_ids).any?
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
