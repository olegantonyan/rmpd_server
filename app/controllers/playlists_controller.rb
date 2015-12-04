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
  end

  # GET /playlists/1/edit
  def edit
    authorize @playlist
  end

  # POST /playlists
  def create
    @playlist = Playlist.new(playlist_params)
    authorize @playlist
    crud_respond @playlist
  end

  # PATCH/PUT /playlists/1
  def update
    authorize @playlist
    @playlist.assign_attributes(playlist_params)
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
    @media_items = policy_scope(MediaItem.includes(:company).all)
  end

  def playlist_params
    res = params.require(:playlist).permit(:name, :description, :company_id, :shuffle)
    Playlist.media_items_attrs.each do |attr|
      res[attr] = params[attr]
    end
    res
  end
end
