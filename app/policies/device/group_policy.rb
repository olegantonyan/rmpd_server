class Device::GroupPolicy < UserCompaniesScope
  def index?
    user.present?
  end

  def show?
    user.root? || (index? && (Device.where(company_id: user.company_ids) & record.devices).any?)
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
      scope.joins(:device_group_memberships).where(device_group_memberships: { device: Device.where(company_id: user.company_ids) }).distinct
    end
  end
end
