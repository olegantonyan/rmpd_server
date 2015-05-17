# encoding: utf-8

class MediaItemUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  
  process :encode_video_for_device
  
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(mp3 mp4 avi wav ogg ogv webm mpeg mpg mov)
  end
  
  def video_extensions
    %w(mp4 avi ogv webm mpeg mpg mov)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
    
  def video? 
    videofile? file
  end
    
  private
  
    def videofile? f
      if video_extensions.find{|ext| f.path.ends_with? ext}
        true
      else
        false
      end
    end
    
    def encode_video_for_device
      return unless video?
      tmp_path = File.join File.dirname(current_path), "#{SecureRandom.hex}.mp4"
      system("ffmpeg -i #{current_path} -vcodec libx264 -acodec aac -strict -2 #{tmp_path}")
      File.rename tmp_path, current_path
    end

end
