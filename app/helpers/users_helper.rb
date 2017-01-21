module UsersHelper
  # rubocop: disable Lint/SafeNavigationChain
  def current_user_has_many_companies?
    current_user&.companies&.size&.to_i > 1
  end
  # rubocop: enable Lint/SafeNavigationChain
end
