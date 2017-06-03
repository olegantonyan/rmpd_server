class Device
  class GroupPolicy < ApplicationPolicy
    def index?
      user.present?
    end

    def show?
      super || (index? && (Device.where(company_id: user.company_ids) & record.devices).any?)
    end

    def create?
      user.present?
    end

    def update?
      super || (index? && (Device.where(company_id: user.company_ids) & record.devices).any?)
    end

    def destroy?
      super || (index? && (Device.where(company_id: user.company_ids) & record.devices).any?)
    end

    class Scope < Scope
      def resolve
        return scope.all if user.root?
        scope.joins(:device_group_memberships).where(device_group_memberships: { device: Device.where(company_id: user.company_ids) }).distinct
      end
    end
  end
end
