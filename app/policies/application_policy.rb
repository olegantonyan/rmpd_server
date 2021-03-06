class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user&.root?
  end

  def show?
    user&.root?
  end

  def create?
    user&.root?
  end

  def new?
    create?
  end

  def update?
    user&.root?
  end

  def edit?
    update?
  end

  def destroy?
    user&.root?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
