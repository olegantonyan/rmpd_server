class MediaItem::Processing < BaseService
  attr_accessor :media_item, :skip_volume_normalization

  delegate :file, to: :media_item

  def call
    begin_process
    if media_item.image?
      convert_image
    else
      encode_video_for_device if media_item.video?
      normalize_audio_volume unless skip_volume_normalization
    end
    finish_process
  end

  private

  def begin_process
    media_item.update(file_processing: true) unless media_item.file_processing
  end

  def finish_process
    media_item.update(file_processing: false)
  end

  def encode_video_for_device
    tmp_path = File.join(File.dirname(file.current_path), "#{SecureRandom.hex}.mp4")
    MediafilesUtils.convert_to_h264(file.current_path, tmp_path)
    File.rename(tmp_path, file.current_path)
  end

  def normalize_audio_volume
    MediafilesUtils.normalize_volume(file.current_path)
    media_item.update(volume_normalized: true)
  end

  def convert_image
    image = MiniMagick::Image.new(media_item.file_path)
    image.resize '1920x1080>'
    image.format 'jpg'
    image.colors 65_536
    image.depth 16
    image.colorspace 'RGB'
    image.write(media_item.file_path)
  end
end
