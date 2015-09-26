module ScopesWithUser
  extend ActiveSupport::Concern

  included do
    scope :accessible_for_user, -> (user) { where company: user.companies }
    scope :accessible_for_company, -> (company) { where company: company }
  end
end
