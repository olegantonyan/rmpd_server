class HomeController < UsersApplicationController
  skip_before_filter :authenticate_user!
  
  def index
    @news_items = NewsItem.order(:created_at => :desc).limit(6).to_a
  end
end
