class MediaItemsController < BaseController
  include Filterrificable

  before_action :set_media_item, only: %i(show edit update destroy)

  # GET /media_items
  # rubocop: disable Metrics/AbcSize, Style/Semicolon, Style/RedundantParentheses
  def index
    @filterrific = initialize_filterrific(
      MediaItem,
      params[:filterrific],
      select_options: {
        with_company_id: policy_scope(Company.all).map { |e| [e.title, e.id] },
        with_type: MediaItem.types.map { |k, _| [MediaItem.human_enum_name(k), k] }
      }
    ) || (on_reset; return)
    @media_items = policy_scope(@filterrific.find.page(page).per_page(per_page)).order(created_at: :desc)
    authorize @media_items
  end
  # rubocop: enable Metrics/AbcSize, Style/Semicolon, Style/RedundantParentheses

  # GET /media_items/1
  def show
    authorize @media_item
  end

  # GET /media_items/new
  def new
    @media_item_multiple = MediaItem::CreateMultiple.new
    authorize @media_item_multiple
  end

  # POST /media_items/create_multiple
  def create_multiple
    @media_item_multiple = MediaItem::CreateMultiple.new(media_item_create_multiple_params)
    authorize @media_item_multiple, :create?
    crud_respond @media_item_multiple
  end

  # DELETE /media_items/1
  def destroy
    authorize @media_item
    crud_respond @media_item
  end

  def destroy_multiple
    media_items = MediaItem.find(params[:media_item_ids])
    media_items.each { |m| authorize m, :destroy? }
    crud_respond MediaItem::DestroyMultiple.new(media_items: media_items)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_media_item
    @media_item = MediaItem.find(params[:id])
  end

  def media_item_params
    params.require(:media_item).permit(:description, :company_id, :type, :file)
  end

  def media_item_create_multiple_params
    params.require(:media_item_create_multiple).permit(:description, :company_id, :type, files: [])
  end

  def crud_responder_default_options
    { success_url: media_items_path }
  end
end
