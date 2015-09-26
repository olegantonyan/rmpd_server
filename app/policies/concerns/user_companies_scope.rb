class UserCompaniesScope < ApplicationPolicy

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.joins(:devices).where("devices.company_id in (?)", user.company_ids).group("device_groups.id")
    end
  end

end
