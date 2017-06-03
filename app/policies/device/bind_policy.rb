class Device
  class BindPolicy < ApplicationPolicy
    def new?
      user.companies.any?
    end

    def create?
      user.company_ids.include?(record.company_id.to_i)
    end
  end
end
