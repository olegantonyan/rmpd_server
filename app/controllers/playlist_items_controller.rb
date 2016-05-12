class PlaylistItemsController < BaseController
  prepend_view_path 'app/views/playlists'

  before_action :set_playlist_item, only: %i(show edit update destroy)

  def show
    authorize @playlist_item
  end

  private

  def set_playlist_item
    @playlist_item = Playlist::Item.find(params[:id])
  end
end
