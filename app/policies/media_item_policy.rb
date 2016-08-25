class MediaItemPolicy < ApplicationPolicy
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
    return false if record.file_processing?
    (super || (index? && user.company_ids.include?(record.company_id))) && !record.playlists.exists?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.where(company: user.companies)
    end
  end
end
