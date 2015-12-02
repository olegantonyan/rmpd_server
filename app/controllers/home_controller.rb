class HomeController < BaseController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    @news_items = NewsItem.latest.to_a
  end
end
