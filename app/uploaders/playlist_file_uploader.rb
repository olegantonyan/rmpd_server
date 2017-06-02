class PlaylistFileUploader < ApplicationUploader
  def extension_white_list
    %w[m3u]
  end

  def filename
    'playlist.m3u' if original_filename
  end
end
