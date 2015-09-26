class PlaylistPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    index?
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
end
