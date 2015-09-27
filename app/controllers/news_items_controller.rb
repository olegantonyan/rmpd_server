class NewsItemsController < BaseController
  skip_before_filter :authenticate_user!
  skip_after_filter :verify_authorized
  skip_after_filter :verify_policy_scoped
  before_action :set_news_item, only: [:show, :edit, :update, :destroy]

  # GET /news_items
  # GET /news_items.json
  def index
    @news_items = NewsItem.order(:created_at => :desc).to_a
  end

  # GET /news_items/1
  # GET /news_items/1.json
  def show
  end

  # GET /news_items/new
  def new
    @news_item = NewsItem.new
  end

  # GET /news_items/1/edit
  def edit
  end

  # POST /news_items
  # POST /news_items.json
  def create
    @news_item = NewsItem.new(news_item_params)
    @news_item.save
    respond_with @news_item
  end

  # PATCH/PUT /news_items/1
  # PATCH/PUT /news_items/1.json
  def update
    @news_item.update(news_item_params)
    respond_with @news_item
  end

  # DELETE /news_items/1
  # DELETE /news_items/1.json
  def destroy
    @news_item.destroy
    respond_with @news_item
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news_item
      @news_item = NewsItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_item_params
      params[:news_item]
    end
end
