class Playlist::ItemPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    super || (index? && user.company_ids.include?(record.playlist.company_id))
  end

  def create?
    user.present?
  end

  def update?
    super || (index? && user.company_ids.include?(record.playlist.company_id))
  end

  def destroy?
    super || (index? && user.company_ids.include?(record.playlist.company_id))
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      joins(:playlist).where(playlists: { company_id: user.company_ids })
    end
  end
end
