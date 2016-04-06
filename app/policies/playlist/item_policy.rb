class Playlist::ItemPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.root? || (index? && user.company_ids.include?(record.playlist.company_id))
  end

  def new?
    create?
  end

  def create?
    user.present?
  end

  def update?
    show?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      joins(:playlist).where(playlists: { company_id: user.company_ids })
    end
  end
end
