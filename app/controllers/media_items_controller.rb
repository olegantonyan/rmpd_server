class MediaItemsController < ApplicationController
  def index # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
    respond_to do |format|
      format.html do
        add_js_data(
          index_path: media_items_path,
          destroy_path: destroy_multiple_media_items_path,
          tags: policy_scope(Tag.ordered).map(&:serialize)
        )
      end
      format.json do
        scoped = policy_scope(MediaItem.includes(:tags, :company).with_attached_file)
        scoped = QueryObject.new(:search_query, :with_tag_ids, :with_company_id, :with_type, :with_library).call(scoped, params)
        scoped = scoped.distinct

        total_count = scoped.count
        media_items = Pagination.new(params).call(scoped).order(created_at: :desc)

        authorize(media_items)

        render json: { data: media_items.map(&:serialize), total_count: total_count }
      end
      format.csv do
        file = Tempfile.new(['media_items_', '.csv'])
        MediaItem.to_csv(filepath: file.path)
        send_file(file.path, type: 'text/csv')
      end
    end
  end

  def new
    add_js_data(
      create_path: media_items_path,
      upload_path: upload_media_items_path,
      tags: policy_scope(Tag.ordered).map(&:serialize)
    )
    authorize(:media_item)
  end

  def upload
    Upload.new(request.body.read, request.headers['Content-Range'], request.headers['X-Upload-Uuid']).save
    render json: {}, status: :created
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def create # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
    media_item_params = params.require(:media_item).permit(policy(:media_item).permitted_attributes)
    upload_params = params.require(:upload).permit(:upload_uuid, :upload_filename, :upload_content_type)

    if upload_params[:upload_content_type] != 'audio/mpeg'
      if upload_params[:upload_filename]&.end_with?('.mp3')
        upload_params[:upload_content_type] = 'audio/mpeg' # HACK: windows sucks at mime types
      else
        render json: { error: t('views.media_items.unsupported_file_format', mime_type: upload_params[:upload_content_type]) }, status: :unprocessable_entity
        return
      end
    end

    # protect filesystem from ../ access
    render(json: { error: 'wrong uuid' }, status: :unprocessable_entity) if ['/', '..'].any? { |i| upload_params[:upload_uuid].include?(i) }

    media_item = MediaItem.new(media_item_params.except(:skip_volume_normalization))
    media_item.skip_file_validation = true
    authorize(media_item)
    if media_item.valid?
      MediaItemProcessingWorker.perform_async(media_item_params.to_unsafe_h, upload_params.to_unsafe_h)
      render json: {}, status: :accepted
    else
      render json: { error: media_item.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy_multiple # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
    media_items = MediaItem.where(id: params[:media_item_ids])
    d = media_items.group_by do |m|
      authorize(m, :destroy?)
      if m.playlists.empty?
        :ok
      else
        :has_playlist
      end
    rescue Pundit::NotAuthorizedError
      :unauthorized
    end
    d.fetch(:ok, []).each(&:destroy)

    render json: {
      deleted: d.fetch(:ok, []).map(&:serialize),
      unauthorized: d.fetch(:unauthorized, []).map(&:serialize),
      has_playlist: d.fetch(:has_playlist, []).map(&:serialize)
    }
  end
end
