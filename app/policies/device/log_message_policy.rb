class Device::LogMessagePolicy < UserCompaniesScope
  def index?
    user.present?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.where(device: Device.where(company_id: user.company_ids))
    end
  end
end
