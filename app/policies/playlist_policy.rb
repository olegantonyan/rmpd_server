class PlaylistPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    super || (index? && user.company_ids.include?(record.company_id))
  end

  def create?
    user.present?
  end

  def update?
    super || (index? && user.company_ids.include?(record.company_id))
  end

  def destroy?
    super || (index? && user.company_ids.include?(record.company_id))
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.where(company: user.companies)
    end
  end

  def permitted_attributes
    attrs = %i(name description company_id shuffle)
    attrs_bg = [playlist_items_background_attributes: %i(_destroy id media_item_id position begin_time begin_date end_time end_date show_duration)]
    attrs_ad = [playlist_items_advertising_attributes: %i(_destroy id media_item_id playbacks_per_day begin_time begin_date end_time end_date show_duration)]
    attrs + attrs_bg + attrs_ad
  end
end
