class PlaylistsController < ApplicationController
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
        playlists = Pagination.new(params).call(scoped).order(created_at: :desc)

        authorize(playlists)

        render(json: { data: playlists.map(&:serialize), total_count: total_count })
      end
    end
  end

  def edit
    @playlist = Playlist.find(params[:id])
    authorize(@playlist)

    add_js_data(editor_js_data_base.merge(update_path: playlist_path(@playlist)))
  end

  def new
    @playlist = Playlist.new(company: current_user.companies.first, name: '', description: '', shuffle: true)
    authorize(@playlist)

    add_js_data(editor_js_data_base.merge(create_path: playlists_path, edit_path: edit_playlist_path(':id')))
  end

  def create
    playlist = Playlist.new(playlist_params.except(:playlist_items))
    authorize(playlist)

    create_or_update(playlist)
  end

  def update
    playlist = Playlist.find(params[:id])
    authorize(playlist)

    create_or_update(playlist)
  end

  def destroy
    @playlist = Playlist.find(params[:id])
    authorize(@playlist)

    if @playlist.destroy_and_remove_from_devices
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

  def create_or_update(playlist)
    service = Playlist::CreateOrUpdate.new(playlist, playlist_params.to_unsafe_h)

    if service.call
      render(json: service.playlist.serialize(with_items: true))
    else
      render(json: { error: service.errors.full_messages.to_sentence }, status: :unprocessable_entity)
    end
  end

  def editor_js_data_base
    {
      playlist: @playlist.serialize(with_items: true),
      media_items_path: media_items_path,
      tags: policy_scope(Tag.ordered).map(&:serialize),
      max_advertising_items: Playlist::MAX_ADVERTISING_ITEMS
    }
  end
end
