class MediaItemPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    super || (index? && user.company_ids.include?(record.company_id)) || record.standard || record.premium
  end

  def new?
    user.present?
  end

  def create?
    user.present? && (user.company_ids.include?(record.company_id) || user.root?)
  end

  def update?
    super || (index? && user.company_ids.include?(record.company_id))
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.root?
      scope.where(company: user.companies).or(scope.standard).or(scope.premium)
    end
  end

  def permitted_attributes
    base = [:description, :company_id, :type, :skip_volume_normalization, tag_ids: []]
    return base unless user.root?
    [:library] + base
  end
end
