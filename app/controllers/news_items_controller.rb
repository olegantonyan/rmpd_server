class NewsItemsController < BaseController
  skip_before_action :authenticate_user!
  before_action :set_news_item, only: %i[show edit update destroy]

  # GET /news_items
  # GET /news_items.json
  def index
    @news_items = policy_scope(NewsItem.all).order(created_at: :desc)
    authorize @news_items
  end

  # GET /news_items/1
  # GET /news_items/1.json
  def show
    authorize @news_item
  end

  # GET /news_items/new
  def new
    @news_item = NewsItem.new
    authorize @news_item
  end

  # GET /news_items/1/edit
  def edit
  end

  # POST /news_items
  # POST /news_items.json
  def create
    @news_item = NewsItem.new(news_item_params)
    authorize @news_item
    crud_respond @news_item
  end

  # PATCH/PUT /news_items/1
  # PATCH/PUT /news_items/1.json
  def update
    authorize @news_item
    @news_item.assign_attributes(news_item_params)
    crud_respond @news_item
  end

  # DELETE /news_items/1
  # DELETE /news_items/1.json
  def destroy
    authorize @news_item
    crud_respond @news_item
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_news_item
    @news_item = NewsItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def news_item_params
    params.require(:news_item).permit(:title, :body)
  end

  def crud_responder_default_options
    { success_url: news_items_path }
  end
end
