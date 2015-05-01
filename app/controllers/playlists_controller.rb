class PlaylistsController < UsersApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]
  before_action :set_media_items, only: [:edit, :new]
  
  # GET /playlists
  def index
    @playlists = policy_scope(Playlist).includes(:media_items, :media_deployments).order(:updated_at => :desc)
  end

  # GET /playlists/1
  def show
    @media_items_in_playlist = policy_scope(MediaItem).includes(:media_deployments).in_playlist_ordered(params[:id])
  end
  
  # GET /playlists/new
  def new
    @playlist = Playlist.new
    @media_deployments = MediaDeployment.includes(:playlist).all
  end
  
  # GET /playlists/1/edit
  def edit
  end

  # POST /playlists
  def create
    @playlist = Playlist.new(playlist_params)
    set_media_deployments_in_playlist(params[:media_items_ids])
    
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
    @playlist.name = params[:playlist][:name]
    @playlist.description = params[:playlist][:description]
    @playlist.company_id = params[:playlist][:company_id]
    @playlist.media_deployments.clear
    set_media_deployments_in_playlist(params[:media_items_ids])
    
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
      @media_items = policy_scope(MediaItem).all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_params
      params.require(:playlist).permit(:name, :description, :company_id)
    end
    
    def set_media_deployments_in_playlist(media_items_ids)
      media_items = MediaItem.where(:id => media_items_ids)
      media_deployment = []
      media_items.each do |i|
        m = MediaDeployment.new
        m.media_item = i
        m.playlist_position = params["media_item_position#{i.id}"]
        @playlist.media_deployments << m
      end
    end
    
end
