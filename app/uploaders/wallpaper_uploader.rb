class WallpaperUploader < ApplicationUploader
  include CarrierWave::MiniMagick

  def content_type_whitelist
    %r{image\/}
  end

  version :thumb do
    process resize_to_fill: [200, 200]
  end

  process :resize_and_convert

  private

  # rubocop: disable Metrics/MethodLength
  def resize_and_convert
    manipulate! do |img|
      img.format('jpg') do |c|
        c.fuzz '3%'
        c.trim '+repage'
        c.resize '1920x1080>'
        c.colorspace 'RGB'
        c.colors 65_536
        c.depth 16
      end
      img
    end
  end
  # rubocop: enable Metrics/MethodLength
end
