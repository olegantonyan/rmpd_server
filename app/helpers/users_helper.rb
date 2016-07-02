module UsersHelper
  def current_user_has_many_companies?
    current_user&.companies&.size&.to_i > 1
  end
end
