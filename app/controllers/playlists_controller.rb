class PlaylistsController < BaseController
  include Filterrificable

  before_action :set_playlist, only: %i(show edit update destroy)

  # GET /playlists
  # rubocop: disable Metrics/AbcSize, Style/Semicolon, Style/RedundantParentheses
  def index
    @filterrific = initialize_filterrific(
      Playlist,
      params[:filterrific],
      select_options: {
        with_company_id: policy_scope(Company.all).map { |e| [e.title, e.id] }
      }
    ) || (on_reset; return)
    filtered = @filterrific.find.page(page).per_page(per_page)
    @playlists = policy_scope(filtered).includes(:media_items, :playlist_items, :company).order(created_at: :desc)
    authorize @playlists
  end
  # rubocop: enable Metrics/AbcSize, Style/Semicolon, Style/RedundantParentheses

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
    crud_respond @playlist, success_url: playlists_path
  end

  # PATCH/PUT /playlists/1
  def update
    authorize @playlist
    @playlist.assign_attributes(playlist_params)
    crud_respond @playlist, success_url: playlist_path(@playlist)
  end

  # DELETE /playlists/1
  def destroy
    authorize @playlist
    crud_respond @playlist, success_url: playlists_path
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
    params.require(:playlist).permit(:name, :description, :company_id, :shuffle).tap do |res|
      Playlist.media_items_attrs.each do |attr|
        res[attr] = params[attr]
      end
    end
  end
end
