class HomeController < BaseController
  skip_before_filter :authenticate_user!
  skip_after_filter :verify_authorized
  skip_after_filter :verify_policy_scoped

  def index
    @news_items = NewsItem.latest.to_a
  end
end
