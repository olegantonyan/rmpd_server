class MediaItemsController < BaseController
  include Filterrificable
  include ChunkedUploadable

  before_action :set_media_item, only: %i[show edit update destroy]

  # GET /media_items
  # rubocop: disable Metrics/AbcSize, Style/Semicolon, Metrics/MethodLength
  def index
    @filterrific = initialize_filterrific(
      MediaItem,
      params[:filterrific],
      select_options: {
        with_company_id: policy_scope(Company.all).map { |e| [e.title, e.id] },
        with_type: MediaItem.types.map { |k, _| [MediaItem.human_enum_name(k), k] },
        with_file_processing: boolean_select,
        with_tag_id: policy_scope(Tag.all.order(:name)).map { |e| [e.name, e.id] }
      }
    ) || (on_reset; return)
    @media_items = policy_scope(@filterrific.find.page(page).per_page(per_page)).order(created_at: :desc)
    authorize @media_items
  end
  # rubocop: enable Metrics/AbcSize, Style/Semicolon, Metrics/MethodLength

  # GET /media_items/1
  def show
    authorize @media_item
  end

  # GET /media_items/new
  def new
    @media_item_multiple = MediaItem::CreateMultiple.new
    authorize @media_item_multiple
  end

  def edit
    authorize @media_item
  end

  def update
    authorize @media_item
    @media_item.assign_attributes(media_item_params)
    crud_respond @media_item
  end

  # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
  def create_multiple
    uploads = media_item_create_multiple_params[:files].map { |file| chunked_upload(file) }
    uploads.map(&:save)
    done_uploads = uploads.select(&:done?)
    if done_uploads.any?
      current_params = media_item_create_multiple_params.merge(files: done_uploads.map(&:file))
      @media_item_multiple = MediaItem::CreateMultiple.new(current_params)
      authorize @media_item_multiple, :create?
      respond_to do |format|
        format.json do
          if @media_item_multiple.save
            render json: {}
          else
            render json: { error: @media_item_multiple.errors.full_messages.to_sentence, files: @media_item_multiple.files.map(&:original_filename) }, status: :unprocessable_entity
          end
        end
        format.html { crud_respond(@media_item_multiple) }
      end
      # done_uploads.map(&:cleanup) # don't need this, thanks to `move_to_cache` and `move_to_store`
    else
      skip_authorization
      render json: {}
    end
  end
  # rubocop: enable Metrics/MethodLength, Metrics/AbcSize

  # DELETE /media_items/1
  def destroy
    authorize @media_item
    crud_respond @media_item
  end

  def destroy_multiple
    media_items = MediaItem.find(params[:media_item_ids])
    media_items.each { |m| authorize m, :destroy? }
    crud_respond MediaItem::DestroyMultiple.new(media_items: media_items), error_url: media_items_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_media_item
    @media_item = MediaItem.find(params[:id])
  end

  def media_item_params
    params.require(:media_item).permit(policy(@media_item).permitted_attributes)
  end

  def media_item_create_multiple_params
    params.require(:media_item_create_multiple).permit(policy(:media_item).permitted_attributes).tap do |i|
      i[:files] = i[:files]&.reject(&:blank?)
      i[:skip_volume_normalization] = i[:skip_volume_normalization] == '1'
    end
  end

  def crud_responder_default_options
    { success_url: media_items_path }
  end
end
