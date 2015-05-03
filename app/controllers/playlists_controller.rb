class PlaylistsController < UsersApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]
  before_action :set_media_items, only: [:edit, :new]
  
  # GET /playlists
  def index
    @playlists = policy_scope(Playlist).includes(:media_items, :media_deployments).order(:updated_at => :desc)
  end

  # GET /playlists/1
  def show
    respond_to do |format|
      format.html
    end
  end
  
  # GET /playlists/new
  def new
    @playlist = Playlist.new
    @media_deployments = MediaDeployment.includes(:playlist).all
    respond_to do |format|
      format.html
    end
  end
  
  # GET /playlists/1/edit
  def edit
  end

  # POST /playlists
  def create
    @playlist = Playlist.new(playlist_params)
    @playlist.deploy_media_items!(media_items_scoped, media_items_positions)
    respond_to do |format|
      if @playlist.save
        format.html { redirect_to @playlist, flash_success(t(:playlist_successfully_created, :name => @playlist.name)) }
      else
        format.html { render :new, flash_error(t(:error_creating_playlist)) }
      end
    end
  end
  
  # PATCH/PUT /playlists/1
  def update
    @playlist.attributes = playlist_params
    @playlist.deploy_media_items!(media_items_scoped, media_items_positions)
    respond_to do |format|
      if @playlist.save
        format.html { redirect_to @playlist, flash_success(t(:playlist_successfully_updated, :name => @playlist.name)) }
      else
        format.html { render :edit, flash_error(t(:error_updating_playlist)) }
      end
    end
  end
  
  # DELETE /playlists/1
  def destroy
    @playlist.destroy
    respond_to do |format|
      format.html { redirect_to playlists_url, flash_success(t(:playlist_successfully_deleted, :name => @playlist.name)) }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = policy_scope(Playlist).includes(:media_items, :media_deployments).find(params[:id])
    end
    
    def set_media_items
      @media_items = policy_scope(MediaItem).order(:created_at => :desc)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_params
      params.require(:playlist).permit(:name, :description, :company_id, :media_items_ids => [], :media_items_positions => [])
    end
    
    def media_items_scoped
      policy_scope(MediaItem).where(:id => params[:media_items_ids])
    end
    
    def media_items_positions
      params[:media_items_positions]
    end
    
end
