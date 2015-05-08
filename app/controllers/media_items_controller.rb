class MediaItemsController < UsersApplicationController
  before_action :set_media_item, only: [:show, :edit, :update, :destroy]
  
  # GET /media_items
  def index
    @filterrific = initialize_filterrific(
      MediaItem,
      params[:filterrific]
    ) or return
    filtered = @filterrific.find.page(params[:page]).per_page(params[:per_page] || 30)
    @media_items = policy_scope(filtered).order(:created_at => :desc)
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /media_items/1
  def show
  end
  
  # GET /media_items/new
  def new
    @media_item = MediaItem.new
  end

  # POST /media_items
  def create
    @media_item = MediaItem.new(media_item_params)
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
    respond_to do |format|
      if bulk_create_media_items
        create_playlist # don't care if it's failed
        flash_success(t(:media_items_successfully_created, :names => (@media_items.map { |i| i.file_identifier }).join(", ")))
        format.html { redirect_to :media_items }
      else
        flash_error(t(:media_items_create_error))
        format.html { render :new }
      end
    end
  end
  
  # DELETE /media_items/1
  def destroy
    @media_item.remove_file!
    @media_item.destroy
    respond_to do |format|
      flash_success(t(:media_item_successfully_deleted, :name => @media_item.file_identifier))
      format.html { redirect_to media_items_path }
    end
  end
  
  # DELETE /media_items/1
  def destroy_multiple
    media_items = params[:media_items]
    respond_to do |format|
      if media_items.nil? || media_items.empty?
        flash_error(t(:media_items_not_selected))
        format.html { redirect_to media_items_path }
      else
        MediaItem.destroy(media_items)  
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
      params.require(:media_item).permit(:file, :description, :company_id)
    end
    
    def bulk_create_media_items
      files = params[:media_item][:file]
      desc = params[:media_item][:description]
      company_id = params[:media_item][:company_id]
      if files.nil?
        @media_item = MediaItem.new(:description => desc, :file => nil, :company_id => company_id) # new item with nil file for validation
        @media_item.valid? # force validations
        return false
      end
      @media_items = files.map{ |f| MediaItem.new(:description => desc, :file => f, :company_id => company_id) }
      @media_items.each do |i|
        unless i.save
          @media_item = i # break and render form with problematic item
          return false
        end
      end
      true
    end
    
    def create_playlist
      return unless params[:create_playlist] == 'true'
      name = params[:playlist_name]
      desc = params[:playlist_description]
      company_id = params[:media_item][:company_id]
      playlist = Playlist.new(:name => name, :description => desc, :company_id => company_id)
      playlist.deploy_media_items!(@media_items, @media_items.map.with_index{|item,index| [item.id, index * 10]})
      playlist.save
    end
    
end
