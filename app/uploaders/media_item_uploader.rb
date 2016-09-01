class MediaItemUploader < ApplicationUploader
  def extension_white_list
    %w(mp3 mp4 avi wav ogg ogv webm mpeg mpg mov mkv jpg jpeg png)
  end

  # def content_type_whitelist
  #  %r{^(image\/|video\/|audio\/)} # does not work for some reason
  # end

  def move_to_cache
    true
  end

  def move_to_store
    true
  end
end
