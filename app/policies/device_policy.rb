class DevicePolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    super || (index? && user.company_ids.include?(record.company_id))
  end

  def update?
    show?
  end

  def destroy?
    user.root?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.where(company: user.companies)
    end
  end

  def permitted_attributes
    base = [:time_zone, :company_id, :name, :wallpaper, :wallpaper_cache, :remove_wallpaper, :message_queue_sync_period, device_group_ids: []]
    return base unless user.root?
    %i(login password password_confirmation) + base
  end
end
