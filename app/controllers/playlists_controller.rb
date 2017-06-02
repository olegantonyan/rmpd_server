class PlaylistsController < BaseController
  include Filterrificable

  before_action :set_playlist, only: %i[show edit update destroy]
  before_action :set_media_items, only: %i[new edit update create]

  # GET /playlists
  # rubocop: disable Metrics/AbcSize, Style/Semicolon
  def index
    @filterrific = initialize_filterrific(
      Playlist,
      params[:filterrific],
      select_options: {
        with_company_id: policy_scope(Company.all).map { |e| [e.title, e.id] }
      }
    ) || (on_reset; return)
    @playlists = policy_scope(@filterrific.find.page(page).per_page(per_page)).order(created_at: :desc)
    authorize @playlists
  end
  # rubocop: enable Metrics/AbcSize, Style/Semicolon

  # GET /playlists/1
  def show
    authorize @playlist
  end

  # GET /playlists/new
  def new
    @playlist = Playlist.new
    authorize @playlist
  end

  # GET /playlists/1/edit
  def edit
    authorize @playlist
  end

  # POST /playlists
  def create
    @playlist = Playlist.new(playlist_params)
    authorize @playlist
    crud_respond Playlist::Creation.new(playlist: @playlist), success_url: playlists_path
  end

  # PATCH/PUT /playlists/1
  def update
    authorize @playlist
    @playlist.assign_attributes(playlist_params)
    crud_respond Playlist::Creation.new(playlist: @playlist), success_url: playlist_path(@playlist)
  end

  # DELETE /playlists/1
  def destroy
    authorize @playlist
    crud_respond @playlist, success_url: playlists_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_playlist
    @playlist = Playlist.includes(playlist_items_advertising: { media_item: :company }, playlist_items_background: { media_item: :company }).find(params[:id])
  end

  def set_media_items
    items = policy_scope(MediaItem.includes(:company).not_processing.successfull)
    @media_items_background = items.background
    @media_items_advertising = items.advertising
  end

  def playlist_params
    params.require(:playlist).permit(policy(:playlist).permitted_attributes)
  end
end
