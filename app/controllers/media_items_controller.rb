class MediaItemsController < UsersApplicationController
  before_action :set_media_item, only: [:show, :edit, :update, :destroy]
  
  # GET /media_items
  def index
    @media_items = MediaItem.all
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
    items = []
    items = params[:media_item][:file].map { |f| MediaItem.new(:description => params[:media_item][:description], :file => f) }
    err = false
    items.each do |i|
      if not i.save
        err = true
        break
      end
    end
    respond_to do |format|
      if not err
        str_items = (items.map { |i| i.file_identifier }).join(", ")
        flash_success "Media items '#{str_items}' were successfully created"
        format.html { redirect_to :media_items }
      else
        flash_error = 'Error uploading some media items'
        format.html { render :media_items }
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
      flash_success "Media item '#{@media_item.file_identifier}' was successfully deleted"
      format.html { redirect_to media_items_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_media_item
      @media_item = MediaItem.find(params[:id])
    end
    
end
