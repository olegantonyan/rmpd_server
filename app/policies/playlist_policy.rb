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
    [:name, :description, :company_id, :shuffle, playlist_items: []]
  end
end
