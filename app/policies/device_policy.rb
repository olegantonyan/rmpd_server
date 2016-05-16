class DevicePolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    super || (index? && user.company_ids.include?(record.company_id))
  end

  def update?
    show?
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.where(company: user.companies)
    end
  end
end
