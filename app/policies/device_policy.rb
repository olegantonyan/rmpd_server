class DevicePolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.root? || (index? && Device.accessible_for_user(user).include?(record))
  end

  def new?
    create?
  end

  def create?
    user.present?
  end

  def update?
    show? # && TODO user has role in a company this device belongs
  end

  def edit?
    update?
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
