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

  # rubocop: disable Metrics/AbcSize
  def destroy?
    return false if record.file_processing? && !record.file_processing_failed?
    (super || (index? && user.company_ids.include?(record.company_id))) && !record.playlists.exists?
  end
  # rubocop: enable Metrics/AbcSize

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.where(company: user.companies)
    end
  end
end
