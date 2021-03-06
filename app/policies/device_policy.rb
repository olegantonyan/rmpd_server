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
    user.root?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.where(company: user.companies)
    end
  end

  def permitted_attributes
    base = %i[time_zone company_id name]
    return base unless user.root?
    %i[login password password_confirmation] + base
  end
end
