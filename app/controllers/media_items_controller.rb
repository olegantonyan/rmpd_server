class MediaItemsController < BaseController
  include Filterrificable

  before_action :set_media_item, only: [:show, :edit, :update, :destroy]

  # GET /media_items
  def index
    @filterrific = initialize_filterrific(
      MediaItem,
      params[:filterrific],
      select_options: {
         with_company_id: policy_scope(Company.all).map { |e| [e.title, e.id] }
      }
    ) || (on_reset; return)
    filtered = @filterrific.find.page(params[:page]).per_page(params[:per_page] || 30)
    @media_items = policy_scope(filtered).includes(:company).order(created_at: :desc)
    authorize @media_items
  end

  # GET /media_items/1
  def show
    authorize @media_item
  end

  # GET /media_items/new
  def new
    @media_item_multiple = MediaItem::MultipleFiles.new
    authorize @media_item_multiple
  end

  # POST /media_items/create_multiple
  def create_multiple
    @media_item_multiple = MediaItem::MultipleFiles.new(media_item_multiple_files_params)
    authorize @media_item_multiple, :create?
    crud_respond @media_item_multiple, success_url: media_items_path
  end

  # DELETE /media_items/1
  def destroy
    authorize @media_item
    crud_respond @media_item
  end

  def destroy_multiple
    media_items = MediaItem.where(id: params[:media_items])
    media_items.each {|m| authorize m, :destroy? }
    if media_items.empty? #TODO responders + form object
      skip_authorization
      flash_error(t(:media_items_not_selected))
    else
      media_items.destroy_all
      flash_success(t(:media_items_successfully_deleted))
    end
    redirect_to media_items_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_media_item
    @media_item = MediaItem.find(params[:id])
  end

  def media_item_params
    params.require(:media_item).permit(:description, :company_id, :type, :file)
  end

  def media_item_multiple_files_params
    params.require(:media_item_multiple_files).permit(:description, :company_id, :type, files: [])
  end

  def bulk_create_media_items
    files = params[:media_item][:file]
    desc = params[:media_item][:description]
    company_id = params[:media_item][:company_id]
    type = params[:media_item][:type]
    if files.nil?
      @media_item = MediaItem.new(:description => desc, :file => nil, :company_id => company_id, type: type) # new item with nil file for validation
      @media_item.valid? # force validations
      return false
    end
    @media_items = files.map{ |f| MediaItem.new(:description => desc, :file => f, :company_id => company_id, type: type) }
    @media_items.each do |i|
      unless i.save
        @media_item = i # break and render form with problematic item
        return false
      end
    end
    true
  end

end
