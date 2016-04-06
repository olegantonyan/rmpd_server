class Playlist::ItemPresenter < BasePresenter
  def size
    h.number_to_human_size(media_item.file.size, precision: 2)
  end

  def type
    media_item.class.human_enum_name(super)
  end
end
