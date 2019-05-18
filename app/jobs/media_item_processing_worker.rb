class MediaItemProcessingWorker # becasuse I need `sidekiq_retries_exhausted`
  include Sidekiq::Worker

  sidekiq_options queue: :files_processing, retry: 3

  sidekiq_retries_exhausted do |msg|
    media_item_params = msg['args'].first
    upload_params = msg['args'].second

    error_message = msg['error_message'].presence || 'unkown error'

    Rollbar.warning('file processing error', error_message: error_message, media_item_params: media_item_params, upload_params: upload_params)
  end

  def perform(media_item_params, upload_params) # rubocop: disable Metrics/AbcSize fine here
    media_item_params.deep_symbolize_keys!
    upload_params.deep_symbolize_keys!

    media_item = build_media_item(media_item_params)

    file_path = Upload.filepath_by_uuid(upload_params[:upload_uuid])
    normalize_audio_volume(media_item, file_path, upload_params[:upload_content_type])
    cache_duration(media_item, file_path)

    media_item.file.attach(io: File.open(file_path),
                           filename: normalize_filename(upload_params[:upload_filename]),
                           content_type: upload_params[:upload_content_type])
    media_item.save!
  end

  private

  def normalize_filename(filename, max_length: 250)
    return filename if filename.length < max_length
    ext = filename.split('.')[-1]
    if ext == filename
      filename.truncate(max_length - 1, omission: '_')
    else
      rest = filename.split('.')[0..-2].join('.')
      [rest.truncate(max_length - ext.length - 1, omission: '_'), ext].join('.')
    end
  end

  def normalize_audio_volume(media_item, file_path, mime_type)
    type = mime_type == 'audio/mpeg' ? 'mp3' : MIME::Types[mime_type].first&.preferred_extension.to_s
    MediafilesUtils.normalize_volume(file_path, type: type)
    media_item.volume_normalized = true
  end

  def cache_duration(media_item, file_path)
    media_item.duration = MediafilesUtils.duration(file_path)
  end

  def build_media_item(media_item_params)
    MediaItem.new(media_item_params.except(:skip_volume_normalization))
  end
end
