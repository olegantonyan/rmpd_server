class DevicePolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    index? && Device.accessible_for_user(user).include?(record)
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

end
