class PlaylistsController < BaseController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]
  before_action :set_media_items, only: [:edit, :new, :create, :update]

  # GET /playlists
  def index
    @playlists = policy_scope(Playlist.all).includes(:media_items, :playlist_items, :company).order(updated_at: :desc)
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
    @playlist_items = Playlist::Item.includes(:playlist).all
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
    crud_respond @playlist
  end

  # PATCH/PUT /playlists/1
  def update
    authorize @playlist
    @playlist.assign_attributes(playlist_params)
    @playlist.deploy_media_items!(media_items_scoped, media_items_positions)
    crud_respond @playlist
  end

  # DELETE /playlists/1
  def destroy
    authorize @playlist
    crud_respond @playlist
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_playlist
    @playlist = policy_scope(Playlist).includes(:media_items, :playlist_items).find(params[:id])
  end

  def set_media_items
    @media_items = policy_scope(MediaItem).includes(:company).all
    #@media_items = policy_scope(MediaItem).joins(:playlist_items).order('playlist_items.position').group('media_items.id, playlist_items.position')
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def playlist_params
    params.require(:playlist).permit(:name, :description, :company_id, media_items_background_ids: [], media_items_background_positions: [])
  end

  def media_items_scoped
    policy_scope(MediaItem).where(:id => params[:media_items_background_ids])
  end

  def media_items_positions
    params[:media_items_background_positions]
  end

end
