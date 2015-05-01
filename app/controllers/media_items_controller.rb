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
  
  # GET /media_items/1/edit
  def edit
  end

  # POST /media_items
  def create
    unless params[:media_item][:file].nil?
      items = params[:media_item][:file].map { |f| MediaItem.new(:description => params[:media_item][:description], :file => f, :company_id => params[:media_item][:company_id]) }
    else
      items = []
      items << MediaItem.new(:description => params[:media_item][:description], :file => params[:media_item][:file], :company_id => params[:media_item][:company_id])
    end
    
    err = false
    items.each do |i|
      if not i.save
        err = true
        @media_item = i
        break
      end
    end
    respond_to do |format|
      if not err
        str_items = (items.map { |i| i.file_identifier }).join(", ")
        format.html { redirect_to :media_items, flash_success(t(:media_items_successfully_created, :names => str_items)) }
      else
        format.html { render :new, flash_error(t(:media_items_create_error)) }
      end
    end
  end
  
  # PATCH/PUT /media_items/1
  def update
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
    
end
