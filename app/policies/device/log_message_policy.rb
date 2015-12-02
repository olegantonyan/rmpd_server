class Device::LogMessagePolicy < UserCompaniesScope
  def index?
    user.present?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.where(device: Device.accessible_for_user(user))
    end
  end
end
