class WallpaperUploader < ApplicationUploader
  include CarrierWave::MiniMagick

  def content_type_whitelist
    %r{image\/}
  end

  version :thumb do
    process resize_to_fill: [200, 200]
  end

  process resize_to_limit: [1920, 1080]

  convert :jpg
end
