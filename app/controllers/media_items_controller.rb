class MediaItemsController < UsersApplicationController
  before_action :set_media_item, only: [:show, :edit, :update, :destroy]
  
  # GET /media_items
  def index
    @media_items = policy_scope(MediaItem).order(:created_at => :desc)
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
        format.html { redirect_to :media_items, flash_success(t(:media_item_successfully_created, :name => @media_item.file_identifier)) }
      else
        format.html { render :new, flash_error(t(:media_items_create_error)) }
      end
    end
  end
  
  # POST /media_items/bulk_create
  def bulk_create
    respond_to do |format|
      if bulk_create_media_items
        create_playlist # don't care if it's failed
        items_names = (@media_items.map { |i| i.file_identifier }).join(", ")
        format.html { redirect_to :media_items, flash_success(t(:media_items_successfully_created, :names => items_names)) }
      else
        format.html { render :new, flash_error(t(:media_items_create_error)) }
      end
    end
  end
  
  # DELETE /media_items/1
  def destroy
    @media_item.remove_file!
    @media_item.destroy
    respond_to do |format|
      format.html { redirect_to media_items_url, flash_success(t(:media_item_successfully_deleted, :name => @media_item.file_identifier)) }
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
