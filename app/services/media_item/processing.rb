class MediaItem::Processing < BaseService
  attr_accessor :media_item

  delegate :file, to: :media_item

  def call
    begin_process
    encode_video_for_device if video?
    normalize_audio_volume
    finish_process
  end

  def video_extensions
    %w(mp4 avi ogv webm mpeg mpg mov mkv)
  end

  private

  def begin_process
    media_item.update(file_processing: true) unless media_item.file_processing
  end

  def finish_process
    media_item.update(file_processing: false)
  end

  def video?
    video_extensions.find { |ext| file.path.ends_with?(ext) }
  end

  def encode_video_for_device
    tmp_path = File.join(File.dirname(file.current_path), "#{SecureRandom.hex}.mp4")
    MediafilesUtils.convert_to_h264(file.current_path, tmp_path)
    File.rename(tmp_path, file.current_path)
  end

  def normalize_audio_volume
    MediafilesUtils.normalize_volume(file.current_path)
  end
end
