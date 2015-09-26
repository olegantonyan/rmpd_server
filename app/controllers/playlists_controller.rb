class PlaylistsController < BaseController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]
  before_action :set_media_items, only: [:edit, :new, :create, :update]

  # GET /playlists
  def index
    @playlists = policy_scope(Playlist.all).includes(:media_items, :media_deployments, :company).order(updated_at: :desc)
    authorize @playlists
  end

  # GET /playlists/1
  def show
    authorize @playlist
  end

  # GET /playlists/new
  def new
    @playlist = Playlist.new
    authorize @playlist
    @media_deployments = MediaDeployment.includes(:playlist).all
    respond_to do |format|
      format.html
    end
  end

  # GET /playlists/1/edit
  def edit
    authorize @playlist
  end

  # POST /playlists
  def create
    @playlist = Playlist.new(playlist_params)
    authorize @playlist
    @playlist.deploy_media_items!(media_items_scoped, media_items_positions)
    respond_to do |format|
      if @playlist.save
        flash_success(t(:playlist_successfully_created, :name => @playlist.name))
        format.html { redirect_to @playlist }
      else
        flash_error("#{t(:error_creating_playlist)}: #{@playlist.errors.full_messages.join(', ')}")
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /playlists/1
  def update
    authorize @playlist
    @playlist.attributes = playlist_params
    @playlist.deploy_media_items!(media_items_scoped, media_items_positions)
    respond_to do |format|
      if @playlist.save
        flash_success(t(:playlist_successfully_updated, :name => @playlist.name))
        format.html { redirect_to @playlist }
      else
        flash_error("#{t(:error_updating_playlist)}: #{@playlist.errors.full_messages.join(', ')}")
        format.html { render :edit }
      end
    end
  end

  # DELETE /playlists/1
  def destroy
    authorize @playlist
    @playlist.destroy
    respond_to do |format|
      flash_success(t(:playlist_successfully_deleted, :name => @playlist.name))
      format.html { redirect_to playlists_url }
    end
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_playlist
    @playlist = policy_scope(Playlist).includes(:media_items, :media_deployments).find(params[:id])
  end

  def set_media_items
    @media_items = policy_scope(MediaItem).includes(:company).all
    #@media_items = policy_scope(MediaItem).joins(:media_deployments).order('media_deployments.playlist_position').group('media_items.id, media_deployments.playlist_position')
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
