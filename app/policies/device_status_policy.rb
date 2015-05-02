class DeviceStatusPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.joins(:device).where("devices.company_id in (?)", user.companies.map{|c| c.id}).group("device_statuses.id")
    end
  end
end