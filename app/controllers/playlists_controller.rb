class PlaylistsController < ApplicationController
  include Paginateble

  def index # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
    respond_to do |format|
      format.html do
        add_js_data(
          index_path: playlists_path,
          edit_path: edit_playlist_path(':id')
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

  def edit
    @playlist = Playlist.find(params[:id])
    authorize(@playlist)

    add_js_data(
      playlist: @playlist.serialize,
      update_path: playlist_path(@playlist)
    )
  end

  def new
    @playlist = Playlist.new(company: current_user.companies.first, name: '', description: '')
    authorize(@playlist)

    add_js_data(
      playlist: @playlist.serialize,
      create_path: playlists_path,
      edit_path: edit_playlist_path(':id')
    )
  end

  def create
    @playlist = Playlist.new(playlist_params)
    authorize(@playlist)

    if @playlist.save
      render json: @playlist.serialize
    else
      render json: { error: @playlist.errors.full_messages.to_sentence }
    end
  end

  def update
    @playlist = Playlist.find(params[:id])
    authorize(@playlist)
    @playlist.assign_attributes(playlist_params)

    if @playlist.save
      render json: @playlist.serialize
    else
      render json: { error: @playlist.errors.full_messages.to_sentence }, status: :unprocessible_entity
    end
  end

  def destroy
    @playlist = Playlist.find(params[:id])
    authorize(@playlist)

    if @playlist.destroy
      flash[:notice] = t('views.playlists.successfully_deleted', playlist: @playlist)
      redirect_to(playlists_path)
    else
      flash[:alert] = t('views.playlists.error_delete')
      redirect_to(edit_playlist_path(@playlist))
    end
  end

  private

  def playlist_params
    params.require(:playlist).permit(policy(:playlist).permitted_attributes)
  end
end
