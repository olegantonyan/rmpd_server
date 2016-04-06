class MediaItemPresenter < BasePresenter
  def playlists
    h.collection_links(super, :name, :playlist_path)
  end

  def size
    h.number_to_human_size(file.size, precision: 2)
  end

  def type
    model.class.human_enum_name(super)
  end
end
