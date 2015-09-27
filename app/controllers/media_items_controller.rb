class MediaItemsController < BaseController
  before_action :set_media_item, only: [:show, :edit, :update, :destroy]

  # GET /media_items
  def index
    @filterrific = initialize_filterrific(
      MediaItem,
      params[:filterrific],
      select_options: {
         with_company_id: policy_scope(Company.all).map { |e| [e.title, e.id] }
      }
    ) or return
    filtered = @filterrific.find.page(params[:page]).per_page(params[:per_page] || 30)
    @media_items = policy_scope(filtered).includes(:company).order(created_at: :desc)
    authorize @media_items

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /media_items/1
  def show
    authorize @media_item
  end

  # GET /media_items/new
  def new
    @media_item = MediaItem.new
    authorize @media_item
  end

  # POST /media_items
  def create
    @media_item = MediaItem.new(media_item_params)
    authorize @media_item
    respond_to do |format|
      if @media_item.save
        flash_success(t(:media_item_successfully_created, :name => @media_item.file_identifier))
        format.html { redirect_to :media_items }
      else
        flash_error(t(:media_items_create_error))
        format.html { render :new }
      end
    end
  end

  # POST /media_items/create_multiple
  def create_multiple
    authorize :media_item, :create?
    respond_to do |format|
      if bulk_create_media_items
        if create_playlist # don't care if it's failed
          flash_success(t(:media_items_successfully_created, :names => (@media_items.map { |i| i.file_identifier }).join(", ")))
        else
          flash_warning t(:media_items_successfully_created_but_playlist_failed)
        end
        format.html { redirect_to :media_items }
      else
        flash_error(t(:media_items_create_error))
        format.html { render :new }
      end
    end
  end

  # DELETE /media_items/1
  def destroy
    authorize @media_item
    @media_item.remove_file!
    @media_item.destroy
    respond_to do |format|
      flash_success(t(:media_item_successfully_deleted, :name => @media_item.file_identifier))
      format.html { redirect_to media_items_path }
    end
  end

  # DELETE /media_items/1
  def destroy_multiple
    media_items = MediaItem.where(id: params[:media_items])
    media_items.each {|m| authorize m, :destroy? }
    respond_to do |format|
      if media_items.empty?
        skip_authorization
        flash_error(t(:media_items_not_selected))
        format.html { redirect_to media_items_path }
      else
        media_items.destroy_all
        flash_success(t(:media_items_successfully_deleted))
        format.html { redirect_to media_items_path }
      end
    end

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_media_item
    @media_item = policy_scope(MediaItem).find(params[:id])
  end

  def media_item_params
    params.require(:media_item).permit(:file, :description, :company_id, :type)
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

  def create_playlist
    return true unless params[:create_playlist] == 'true'
    name = params[:playlist_name]
    desc = params[:playlist_description]
    company_id = params[:media_item][:company_id]
    playlist = Playlist.new(:name => name, :description => desc, :company_id => company_id)
    playlist.deploy_media_items!(@media_items, @media_items.map.with_index{|item,index| [item.id, index * 10]})
    playlist.save
  end

end
