# encoding: utf-8

class MediaItemUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  
  version :video_for_device, if: :video? do
    process :encode_video_for_device
    
  end
  
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
    %w(mp3 mp4 avi wav ogg ogv webm mpeg mpg)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  
  private
    
    def video? file
      if file.path.ends_with?('avi') || file.path.ends_with?('mp4') || file.path.ends_with?('mpeg') || file.path.ends_with?('mpg') \
        || file.path.ends_with?('ogv') || file.path.ends_with?('webm')
        true
      else
        false
      end
    end
    
    def encode_video_for_device
      puts "*********"
      puts "#{video_for_device_file.path}"
      puts "encoding video"
      #system("ffmpeg -i #{file.path} -vcodec libx264 -acodec aac -strict -2 ~/Desktop/output.mp4")
      # ffmpeg -i /mnt/video/video/Other/SDFF_Jason_Krause_Demo.mpg -vcodec libx264 -acodec aac -strict -2 ~/Desktop/output.mp4
      
      puts "finish encoding"
      puts "*********"
    end

end
