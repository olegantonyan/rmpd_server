class DeviceStatusPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.joins(:device).where("devices.company_id in (?)", user.companies.map{|c| c.id}).group("device_statuses.id")
    end
  end
end