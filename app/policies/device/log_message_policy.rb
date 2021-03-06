class Device
  class LogMessagePolicy < ApplicationPolicy
    def index?
      user.present?
    end

    class Scope < Scope
      def resolve
        return scope.all if user.root?
        scope.joins(:device).where('devices.company_id in (?)', user.company_ids).distinct
      end
    end
  end
end
