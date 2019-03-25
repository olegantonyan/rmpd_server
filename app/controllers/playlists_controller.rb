class PlaylistsController < ApplicationController
  include Paginateble

  def index # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
    respond_to do |format|
      format.html do
        add_js_data(
          index_path: playlists_path,
          show_path: playlist_path(':id')
        )
      end
      format.json do
        scoped = policy_scope(Playlist.includes(:playlist_items, :media_items, :company))
        scoped = QueryObject.new(:search_query, :with_company_id).call(scoped, params)
        scoped = scoped.distinct

        total_count = scoped.count
        playlists = scoped.limit(limit).offset(offset).order(created_at: :desc)

        authorize(playlists)

        render json: { data: playlists.map(&:serialize), total_count: total_count }
      end
    end
  end

  def show
    @playlist = Playlist.find(params[:id])
    authorize(@playlist)

    add_js_data(
      playlist: @playlist.serialize
    )
  end

  def new
    @playlist = Playlist.new
    authorize @playlist
  end

  def create
    @playlist = Playlist.new(playlist_params)
    authorize @playlist
  end

  def update
    authorize @playlist
    @playlist.assign_attributes(playlist_params)
  end

  def destroy
    authorize @playlist
  end

  private

  def playlist_params
    params.require(:playlist).permit(policy(:playlist).permitted_attributes)
  end
end
