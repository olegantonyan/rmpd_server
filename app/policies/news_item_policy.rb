class NewsItemPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    index?
  end

  def new?
    create?
  end

  def create?
    user.try(:root?)
  end

  def update?
    create?
  end

  def edit?
    update?
  end

  def destroy?
    create?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end

end
