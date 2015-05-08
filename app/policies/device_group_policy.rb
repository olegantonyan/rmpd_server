class DeviceGroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.joins(:devices).where("devices.company_id in (?)", user.companies.map{|c| c.id}).group("device_groups.id")
    end
  end
end