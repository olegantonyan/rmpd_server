module PlaylistLegacy
  extend ActiveSupport::Concern

  included do
    after_save :store_file
    mount_uploader :file, PlaylistFileUploader
  end

  def create_playlist_file
    tempfile = Tempfile.new(['playlist', '.m3u'])
    playlist_items.includes(:media_item).each do |deployment| # TODO: fix problem with join in association
      tempfile.puts deployment.media_item.file_identifier
    end
    tempfile.close
    self.file = tempfile
    tempfile.unlink
  end

  def store_file
    create_playlist_file
    Playlist.skip_callback(:save, :after, :store_file) # skipping callback is required to prevent recursion
    save # save newly created file in db
    Playlist.set_callback(:save, :after, :store_file)
  end
end
