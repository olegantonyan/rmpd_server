module UsersHelper
  def many_companies?
    current_user.companies.size > 1
  end
end
