class TagPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    super || index?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.all # NOTE: scope tags to company maybe?
    end
  end
end
