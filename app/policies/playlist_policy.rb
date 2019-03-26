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
    playlist_items_attrs = [:id, :begin_date, :end_date, :begin_time, :end_time, :position, :playbacks_per_day, :wait_for_the_end, :media_item_id, :type] # rubocop: disable Style/SymbolArray
    [:name, :description, :company_id, :shuffle, playlist_items: playlist_items_attrs]
  end
end
