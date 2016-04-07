class Playlist::ItemPresenter < BasePresenter
  def size
    h.number_to_human_size(media_item.file.size, precision: 2)
  end

  def type
    media_item.class.human_enum_name(super)
  end

  def file_identifier
    if media_item.file_processing?
      "#{h.sanitize(super.to_s)} #{h.icon('cogs')}".html_safe
    else
      super
    end
  end
end
